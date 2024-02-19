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
    
    func getProductModels(from cartProducts: [ProductItem]) -> ProductModels {
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
    
    func updateUI(with actualProducts: [ProductItem], currentModels: [String]) {
        let actualModels: [String] = actualProducts.compactMap { $0.model }
        
        let currentModelsSet = Set(currentModels)
        let actualModelsSet = Set(actualModels)
        let missingModels = currentModelsSet.subtracting(actualModelsSet)
        
        print("missingModels - \(missingModels)")
        print("models - \(actualModels)")
        
        if !missingModels.isEmpty {
            self.output?.markProductsDepricated(models: Array(missingModels))
        }
    }
}

// реализовать метод проверки актуальности добавленных в корзину продуктов на сервере
extension CartFirebaseService: CartModelInput {
    
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
                        self.updateUI(with: actualProducts, currentModels: currentModels)
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
