//
//  CartFirebaseService.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 13.02.24.
//

import UIKit

struct ProductModels {
    let manModels: [String]
    let womanModels: [String]
}

// Протокол для модели данных
protocol CartModelInput: AnyObject {
    func fetchData()
    func removeCartProduct(model:String, index:Int)
    func checkingActualCurrentCartProducts(cartProducts: [ProductItem])
}
    
final class CartFirebaseService {
    
    weak var output: CartModelOutput?
    private let serviceFB = FirebaseService.shared
    let checkingProduct = CheckingProductCloudFirestoreService()
    
    init(output: CartModelOutput) {
        self.output = output
    }
    
    deinit {
        print("deinit CartFirebaseService")
    }
}

// MARK: - Setting
private extension CartFirebaseService {
    
    func fetchActualCurrentCartProducts(for models: [String], at path: String, completion: @escaping ([ProductItem]?, Error?) -> Void) {
        guard !models.isEmpty else { return }
        
        checkingProduct.fetchActualCurrentCartProducts(path: path, models: models) { products, error in
            completion(products, error)
        }
    }
    
    ///получаем список моделей для мужчин и женщин
    func getProductModels(from cartProducts: [ProductItem]) -> ProductModels {
        /// если мы ишем по id то можем не привязываться к gender
        let manModels: [String] = cartProducts.compactMap {
            if $0.gender == "Мужские", let model = $0.model {
                return model
            } else {
                return nil
            }
        }

        let womanModels: [String] = cartProducts.compactMap {
            if $0.gender == "Женские", let model = $0.model {
                return model
            } else {
                return nil
            }
        }
        
        return ProductModels(manModels: manModels, womanModels: womanModels)
    }
    
    ///получаем список устаревшие модели
    func getOutdatedModels(with actualProducts: [ProductItem], currentModels: [String]) -> [String] {

        let actualModels: [String] = actualProducts.compactMap { $0.model }
        
        let currentModelsSet = Set(currentModels)
        let actualModelsSet = Set(actualModels)
        let outdatedModels = currentModelsSet.subtracting(actualModelsSet)
        return Array(outdatedModels)
    }


    ///если outdatedModel появится на сервере снова в корзине он не обновится
    func updateUI(cartProduct: [ProductItem], outdatedModels: [String]) {
        
        if !outdatedModels.isEmpty {
            let (updateCartProducts, modifiedProducts)  = changeOutdatedProducts(products: cartProduct, with: outdatedModels)
            
            if !modifiedProducts.isEmpty {
                serviceFB.currentCartProducts = updateCartProducts
                output?.updateOutdatedProducts(products: updateCartProducts)
                addItemsToRemoteCartProducts(modifiedProducts: modifiedProducts)
            }
        }
    }
    
    ///изменяем поля для устревших продуктов + заменяем эти объекты в cartProducts
    ///возвращаем общий cartProducts и измененные продукты
    func changeOutdatedProducts(products: [ProductItem], with models: [String]) -> ([ProductItem], [ProductItem]) {
       
        var cartProducts = products
        // Находим устаревшие продукты, которые есть в models
        let outdatedProducts = cartProducts.filter { product in
            guard let model = product.model, product.isNotAvailoble == nil  else { return false }
            return models.contains(model)
        }
        
        // Удаляем устаревшие продукты из cartProducts
        cartProducts.removeAll { product in
            guard let model = product.model, product.isNotAvailoble == nil  else { return false }
            return models.contains(model)
        }
        
        /// сравнение для активации addedButton должно быть по id
        // Обновляем поля продуктов в устаревших продуктах
        let modifiedProducts = outdatedProducts.map { product -> ProductItem in
            var dict = product.dictionaryRepresentation
            dict["category"] = nil
            dict["strengthIndex"] = nil
            dict["season"] = nil
            dict["color"] = nil
            dict["material"] = nil
            dict["description"] = nil
            dict["price"] = nil
            dict["refImage"] = nil
            dict["shops"] = ["Нет в наличии"]
            dict["originalContent"] = nil
            dict["isNotAvailoble"] = true
            return ProductItem(dict: dict)
        }
        
        // Добавляем обновленные продукты обратно в cartProducts
        cartProducts.append(contentsOf: modifiedProducts)
        return (cartProducts, modifiedProducts)
    }
    
    ///перезаписываем в Cloud Firestore устаревшие продукты
    func addItemsToRemoteCartProducts(modifiedProducts: [ProductItem]) {

        modifiedProducts.forEach { product in
            let dict = product.dictionaryRepresentation.compactMapValues { $0 }
            guard let model = product.model, !model.isEmpty else { return }
            serviceFB.addItemForCartProduct(item: dict, nameDocument: model)
        }
    }
}


// MARK: - CartModelInput
extension CartFirebaseService: CartModelInput {
    
    ///делаем запрос в CloudFirestore на актуальность товаров в корзине
    func checkingActualCurrentCartProducts(cartProducts: [ProductItem]) {
        var actualProducts: [ProductItem] = []
        var currentModels: [String] = []
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let productModels = self.getProductModels(from: cartProducts)
            
            if productModels.manModels.count + productModels.womanModels.count != cartProducts.count {
                return
            }
            currentModels = productModels.manModels + productModels.womanModels
            
            let semaphore = DispatchSemaphore(value: 0)
            
            self.fetchActualCurrentCartProducts(for: productModels.manModels, at: "productsMan") { products, error in
                if let products = products, error == nil {
                    actualProducts += products
                }
                semaphore.signal()
            }
            semaphore.wait()
            
            self.fetchActualCurrentCartProducts(for: productModels.womanModels, at: "productsWoman") { products, error in
                        if let products = products, error == nil {
                            actualProducts += products
                        }
                        semaphore.signal()
                    }
                    semaphore.wait()
                    
                    DispatchQueue.main.async {
                        let outdatedModels = self.getOutdatedModels(with: actualProducts, currentModels: currentModels)
                        self.updateUI(cartProduct: cartProducts, outdatedModels: outdatedModels)
                    }
                }
            }
    
    func fetchData() {
        serviceFB.userIsAnonymously { [weak self] isAnonymous in
            let product = self?.serviceFB.currentCartProducts ?? []
            let isAnonymousUser = isAnonymous ?? true
            self?.output?.updateData(cartProduct: product, isAnonymousUser: isAnonymousUser)
        }
    }
    
    func removeCartProduct(model:String, index:Int) {
        /// если не получится удалить - нет сети
        serviceFB.currentCartProducts?.remove(at: index)
        serviceFB.removeItemFromCartProduct(model)
    }
}
