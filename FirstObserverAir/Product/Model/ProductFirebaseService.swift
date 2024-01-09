//
//  ProductFirebaseService.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 3.01.24.
//

import Foundation

// Протокол для модели данных
protocol ProductModelInput: AnyObject {
    func fetchPinAndShopForProduct(shops: [String]?, model: String?)
    func addItemForCartProduct(_ productItem: ProductItem, completion: @escaping (Error?) -> Void)
}

class ProductFirebaseService {
    
    weak var output: ProductModelOutput?
    
    let serviceFB = FirebaseService.shared

    init(output: ProductModelOutput) {
        self.output = output
    }
}

extension ProductFirebaseService: ProductModelInput {
    func addItemForCartProduct(_ productItem: ProductItem, completion: @escaping (Error?) -> Void) {
        
        guard let model = productItem.model, !model.isEmpty else { return }
    }
    
    func fetchPinAndShopForProduct(shops: [String]?, model: String?) {
        
        var isAddedToCard = false
        var shopsForProduct:[Shop] = []
        var pinMall:[Pin] = []
        
        if let model = model {
            isAddedToCard = addItemToCart(currentModel: model)
        }
        
        if let shops = shops {
            shopsForProduct = fetchShops(shopsProduct: shops)
        }
        
        pinMall = fetchPinMall(shopsForProduct: shopsForProduct)
        
        output?.updateData(shops: shopsForProduct, pins: pinMall, isAddedToCard: isAddedToCard)
    }
    
    
}

private extension ProductFirebaseService {
    
    func addItemToCart(currentModel:String) -> Bool {
        guard let cartProduct = serviceFB.currentCartProducts else {
            print("Returned message for analytic FB Crashlytics error ProductFirebaseService func addItemToCart(currentModel:String) -> Bool")
            return false
        }
        return cartProduct.contains { $0.model == currentModel }
    }
    
    func createUniqueMallArray(from shops: [Shop]) -> [String] {
        
        var mallSet = Set<String>()
        for shop in shops {
            mallSet.insert(shop.mall ?? "")
        }
        let uniqueMallArray = Array(mallSet)
        
        return uniqueMallArray
    }
    
    
    func fetchShops(shopsProduct: [String]) -> [Shop] {
        var shopsList: [Shop] = []
        let gender = serviceFB.currentGender
        
        guard let allShops = serviceFB.shops[gender] else {
            print("Returned message for analytic FB Crashlytics error ProductFirebaseService func fetchShops(shopsProduct: [String]) -> [Shop]")
            return shopsList
        }
        
        allShops.forEach { shop in
            if shopsProduct.contains(shop.name ?? "") {
                shopsList.append(shop)
            }
        }
        return shopsList
    }
    
    func fetchPinMall(shopsForProduct: [Shop]) -> [Pin] {
    
        var pinList: [Pin] = []

        guard let pinMall = serviceFB.pinMall else {
            print("Returned message for analytic FB Crashlytics error ProductFirebaseService func fetchPinMall(shopsForProduct: [Shop]) -> [Pin]")
            return pinList
        }
        // тут мы создаем список malls в котором есть данный Shop (мы заложили возможность что один товар может быть в разных Shop, то есть продукт может быть в двух shop в одном mall?) (но у нас правило один уникальный продукт для mall)?
        let mallList = createUniqueMallArray(from: shopsForProduct)
        
        pinMall.forEach { pin in
            if mallList.contains(pin.name ?? "") {
                pinList.append(pin)
            }
        }
        return pinList
    }
}


//    func fetchPinMall(shopsProduct: [String]) -> [Pin]? {
//
//        let gender = serviceFB.currentGender
//        var pinList: [Pin] = []
//        var shopsList: [Shop] = []
//
//        guard let allShops = serviceFB.shops[gender], let pinMall = serviceFB.pinMall else {return nil}
//        // тут мы создаем список malls в котором есть данный Shop (мы заложили возможность что один товар может быть в разных Shop, то есть продукт может быть в двух shop в одном mall?) (но у нас правило один уникальный продукт для mall)?
//        allShops.forEach { shop in
//            if shopsProduct.contains(shop.name ?? "") {
//                shopsList.append(shop)
//            }
//        }
//
//        let mallList = createUniqueMallArray(from: shopsList)
//
//        pinMall.forEach { pin in
//            if mallList.contains(pin.name ?? "") {
//                pinList.append(pin)
//            }
//        }
//        return pinList
//    }
    
