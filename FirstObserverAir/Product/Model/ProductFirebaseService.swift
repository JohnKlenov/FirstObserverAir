//
//  ProductFirebaseService.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 3.01.24.
//

import Foundation

// Протокол для модели данных
protocol ProductModelInput: AnyObject {
    func fetchPinAndShopForProduct(_ shops: [String])
}

class ProductFirebaseService {
    
    weak var output: ProductModelOutput?
    
    let serviceFB = FirebaseService.shared

    init(output: ProductModelOutput) {
        self.output = output
    }
}

extension ProductFirebaseService: ProductModelInput {
    func fetchPinAndShopForProduct(_ shops: [String]) {
        output?.updateData(shops: [], pins: [])
    }
}
