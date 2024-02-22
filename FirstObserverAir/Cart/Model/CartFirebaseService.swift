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

private extension CartFirebaseService {
    
    func fetchActualCurrentCartProducts(for models: [String], at path: String, completion: @escaping ([ProductItem]?, Error?) -> Void) {
        guard !models.isEmpty else {
            print("!models.isEmpty - \(models)")
            return
        }
        
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
    ///тут нужно продумать возврат [] если outdatedModels уже product.isNotAvailable != nil
    ///тогда не будет лишний раз обновлятся UI
    func getOutdatedModels(with actualProducts: [ProductItem], currentModels: [String]) -> [String] {

        let actualModels: [String] = actualProducts.compactMap { $0.model }
        
        let currentModelsSet = Set(currentModels)
        let actualModelsSet = Set(actualModels)
        let outdatedModels = currentModelsSet.subtracting(actualModelsSet)
        
        print("actualModels - \(actualModels)")
        print("outdatedModels - \(outdatedModels)")
        return Array(outdatedModels)
    }
    
    func updateUI(cartProduct: [ProductItem], outdatedModels: [String]) {
        
        if !outdatedModels.isEmpty {
            print("!outdatedModels.isEmpty")
            let (updateCartProducts, modifiedProducts)  = changeOutdatedProducts(products: cartProduct, with: outdatedModels)
            print("updateCartProducts - \(updateCartProducts.count)")
            print("modifiedProducts - \(modifiedProducts.count)")
            serviceFB.currentCartProducts = updateCartProducts
            output?.updateOutdatedProducts(products: updateCartProducts)
            addItemsToRemoteCartProducts(modifiedProducts: modifiedProducts)
        } else {
            print("all cartProduct actual")
        }
    }
    
    ///изменяем поля для устревших продуктов
    func changeOutdatedProducts(products: [ProductItem], with models: [String]) -> ([ProductItem], [ProductItem]) {
        /// что если available пустой?
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
    
    func addItemsToRemoteCartProducts(modifiedProducts: [ProductItem]) {

        modifiedProducts.forEach { product in
            let dict = product.dictionaryRepresentation.compactMapValues { $0 }
            guard let model = product.model, !model.isEmpty else { return }
            serviceFB.addItemForCartProduct(item: dict, nameDocument: model)
        }
    }
}

// реализовать метод проверки актуальности добавленных в корзину продуктов на сервере
extension CartFirebaseService: CartModelInput {
    
  
    ///делаем запрос в CloudFirestore на актуальность товаров в корзине
    func checkingActualCurrentCartProducts(cartProducts: [ProductItem]) {
        var actualProducts: [ProductItem] = []
        var currentModels: [String] = []
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let productModels = self.getProductModels(from: cartProducts)
            
            if productModels.manModels.count + productModels.womanModels.count != cartProducts.count {
                print("Сумма элементов в manModels и womanModels не равна cartProducts.count")
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



// MARK: - Trash

//    func checkingActualCurrentCartProducts(cartProducts: [ProductItem]) {
//
//        var actualManProducts: [ProductItem]?
//        var actualWomanProducts: [ProductItem]?
//        var actualProducts: [ProductItem] = []
//        var currentModels: [String] = []
//
//        DispatchQueue.global().async { [weak self] in
//
//            guard let self = self else {
//                print("CartFirebaseService guard let self = self else ")
//                return
//            }
//
//            let manModels: [String] = cartProducts.compactMap {
//                if $0.gender == "Мужские", let model = $0.model {
//                    return model
//                } else {
//                    return nil
//                }
//            }
//
//            let womanModels: [String] = cartProducts.compactMap {
//                if $0.gender == "Женские", let model = $0.model {
//                    return model
//                } else {
//                    return nil
//                }
//            }
//
//            if manModels.count + womanModels.count != cartProducts.count {
//                print("Сумма элементов в manModels и womanModels не равна cartProducts.count")
//                return
//            }
//
//            currentModels = manModels + womanModels
//
//
//            let semaphore = DispatchSemaphore(value: 0)
//
//            if !manModels.isEmpty {
//                self.checkingProduct.fetchActualCurrentCartProducts(path: "productsMan", models: manModels) { products, error in
//                    print("fetchActualCurrentCartProducts(path: productsMan")
//                    // code ..
//                    if let products = products, error == nil {
//                        actualManProducts = products
//                    }
//                    semaphore.signal()
//                }
//                semaphore.wait()
//            }
//
//            if !womanModels.isEmpty {
//                self.checkingProduct.fetchActualCurrentCartProducts(path: "productsWoman", models: womanModels) { products, error in
//                    print("fetchActualCurrentCartProducts(path: productsWoman")
//                    // code ..
//                    if let products = products, error == nil {
//                        actualWomanProducts = products
//                    }
//                    semaphore.signal()
//                }
//                semaphore.wait()
//            }
//
//            DispatchQueue.main.async {
//                // обновить UI
//                if let actualWomanProducts = actualWomanProducts {
//                    actualProducts += actualWomanProducts
//                }
//
//                if let actualManProducts = actualManProducts {
//                    actualProducts += actualManProducts
//                }
//
//                let actualModels: [String] = actualProducts.compactMap {
//                    if let model = $0.model {
//                        return model
//                    } else {
//                        return nil
//                    }
//                }
//
//                ///В missingModels теперь будут элементы, которые есть в currentModels, но отсутствуют в actualModels.
//                let currentModelsSet = Set(currentModels)
//                let actualModelsSet = Set(actualModels)
//                let missingModels = currentModelsSet.subtracting(actualModelsSet)
//
//                print("missingModels - \(missingModels)")
//                print("models - \(actualModels)")
//
//                if !missingModels.isEmpty {
//                    self.output?.markProductsDepricated(models: Array(missingModels))
//                }
//            }
//        }
//    }
