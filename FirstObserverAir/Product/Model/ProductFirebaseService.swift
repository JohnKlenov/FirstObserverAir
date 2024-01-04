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
        output?.updateData(shops: [], pins: [], isAddedToCard: isAddedToCard)
    }
}

private extension ProductFirebaseService {
    
    func addItemToCart(currentModel:String) -> Bool {
        guard let cartProduct = serviceFB.currentCartProducts else { return false }
        return cartProduct.contains { $0.model == currentModel }
    }
    
    
}


