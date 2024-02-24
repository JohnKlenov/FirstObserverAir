//
//  ProductFirebaseService.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 3.01.24.
//

import Foundation

// Протокол для модели данных
protocol ProductModelInput: AnyObject {
    func fetchPinAndShopForProduct(shops: [String]?, model: String?, gender:String?)
    func addItemForCartProduct(_ productItem: ProductItem)
}

final class ProductFirebaseService {
    
    weak var output: ProductModelOutput?
    
    let serviceFB = FirebaseService.shared

    init(output: ProductModelOutput) {
        self.output = output
    }
}

// MARK: - ProductModelInput
extension ProductFirebaseService: ProductModelInput {

    func addItemForCartProduct(_ productItem: ProductItem) {
        
        if let index = serviceFB.currentCartProducts?.firstIndex(where: { $0.model == productItem.model && $0.gender == productItem.gender }) {
            // Элемент найден, заменяем его
            print("addItemForCartProduct - Элемент найден, заменяем его в currentCartProducts")
            serviceFB.currentCartProducts?[index] = productItem
        } else {
            // Элемент не найден, добавляем его
            print("addItemForCartProduct - Элемент не найден, добавляем его в currentCartProducts")
            serviceFB.currentCartProducts?.append(productItem)
        }

        guard let model = productItem.model, !model.isEmpty else { return }

        // Удалите из словаря все пары ключ-значение, где значение равно nil
        let filteredData = productItem.dictionaryRepresentation.compactMapValues { $0 }
        serviceFB.addItemForCartProduct(item: filteredData, nameDocument: model)
    }
    
    func fetchPinAndShopForProduct(shops: [String]?, model: String?, gender:String?) {
        
        var isAddedToCard = false
        var shopsForProduct:[Shop] = []
        var pinMall:[Pin] = []
        
        if let model = model, let gender = gender {
            isAddedToCard = addItemToCart(currentModel: model, gender: gender)
        }
        
        if let shops = shops {
            shopsForProduct = fetchShops(shopsProduct: shops)
        }
        
        pinMall = fetchPinMall(shopsForProduct: shopsForProduct)
        
        output?.updateData(shops: shopsForProduct, pins: pinMall, isAddedToCard: isAddedToCard)
    }
    
    
}

// MARK: - Seeting
private extension ProductFirebaseService {
    
    /// сравнение для активации addedButton должно быть по id
    func addItemToCart(currentModel:String, gender: String) -> Bool {
        guard let cartProduct = serviceFB.currentCartProducts else {
            print("Returned message for analytic FB Crashlytics error ProductFirebaseService func addItemToCart(currentModel:String) -> Bool")
            return false
        }
        return cartProduct.contains { $0.model == currentModel && $0.gender == gender && $0.isNotAvailoble == nil}
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

