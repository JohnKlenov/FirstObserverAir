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
}
    
final class CartFirebaseService {
    
    weak var output: CartModelOutput?
    private let serviceFB = FirebaseService.shared
    
    init(output: CartModelOutput) {
        self.output = output
        
    }
}

extension CartFirebaseService: CartModelInput {
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
