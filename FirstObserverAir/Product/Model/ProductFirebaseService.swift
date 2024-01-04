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
}

class ProductFirebaseService {
    
    weak var output: ProductModelOutput?
    
    let serviceFB = FirebaseService.shared

    init(output: ProductModelOutput) {
        self.output = output
    }
}

extension ProductFirebaseService: ProductModelInput {
    func fetchPinAndShopForProduct(shops: [String]?, model: String?) {
        
        guard let shops = shops, let model = model else {
            output?.updateData(shops: nil, pins: nil, isAddedToCard: false)
            return
        }
        
        let isAddedToCard = addItemToCart(currentModel: model)
        let shopsForProduct = fetchShops(shopsProduct: shops)
        let pinMall = fetchPinMall(shopsForProduct: <#T##[Shop]#>)
        
        output?.updateData(shops: shopsForProduct, pins: [], isAddedToCard: isAddedToCard)
    }
}

private extension ProductFirebaseService {
    
    func addItemToCart(currentModel:String) -> Bool {
        guard let cartProduct = serviceFB.currentCartProducts else { return false }
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
    
    func fetchShops(shopsProduct: [String]) -> [Shop]? {
        var shopsList: [Shop] = []
        let gender = serviceFB.currentGender
        
        guard let allShops = serviceFB.shops[gender] else {return nil}
        
        allShops.forEach { shop in
            if shopsProduct.contains(shop.name ?? "") {
                shopsList.append(shop)
            }
        }
        return shopsList
    }
    
    func fetchPinMall(shopsForProduct: [Shop]) -> [Pin]? {
    
        var pinList: [Pin] = []

        guard let pinMall = serviceFB.pinMall else {return nil}
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
    
