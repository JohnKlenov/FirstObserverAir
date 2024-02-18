//
//  CartFirebaseService.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 13.02.24.
//

import UIKit

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
}
// реализовать метод проверки актуальности добавленных в корзину продуктов на сервере
extension CartFirebaseService: CartModelInput {
    func checkingActualCurrentCartProducts(cartProducts: [ProductItem]) {
        
//        var lastError: Error?
        var actualManProducts: [ProductItem]?
        var actualWomanProducts: [ProductItem]?
        DispatchQueue.global().async { [weak self] in
            
            guard let self = self else {
                print("CartFirebaseService guard let self = self else ")
                return
            }
            
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
            
            if manModels.count + womanModels.count != cartProducts.count {
                print("Сумма элементов в manModels и womanModels не равна cartProducts.count")
                return
            }
            
            let semaphore = DispatchSemaphore(value: 0)
            
            self.checkingProduct.fetchActualCurrentCartProducts(path: "productsMan", models: manModels) { products, error in
                // code ..
                if let products = products, error == nil {
                    actualManProducts = products
                }
                semaphore.signal()
            }
            semaphore.wait()
            
            self.checkingProduct.fetchActualCurrentCartProducts(path: "productsWoman", models: womanModels) { products, error in
                // code ..
                if let products = products, error == nil {
                    actualWomanProducts = products
                }
                semaphore.signal()
            }
            semaphore.wait()

            DispatchQueue.main.async {
                // обновить UI
                guard let actualWomanProducts = actualWomanProducts, let actualManProducts = actualManProducts else { return }
                let actualProducts = actualWomanProducts + actualManProducts
                let models: [String] = actualProducts.compactMap {
                    if let model = $0.model {
                        return model
                    } else {
                        return nil
                    }
                }
                print("models - \(models)")
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
