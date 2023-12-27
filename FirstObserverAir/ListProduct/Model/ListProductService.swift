//
//  ListProductService.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 27.12.23.
//

import Foundation

// Протокол для модели данных
protocol ListProductModelInput: AnyObject {
    func fetchProduct(completion: @escaping ([ProductItem]?, Error?) -> Void)
}

final class ListProductService {
    
    let serviceFB = FirebaseService.shared
    
}

extension ListProductService: ListProductModelInput {
    func fetchProduct(completion: @escaping ([ProductItem]?, Error?) -> Void) {
        completion(nil, nil)
    }
}
