//
//  ModelDataTransformation.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 5.02.24.
//

import Foundation

class ModelDataTransformation {
    
    static func createItem(malls: [PreviewSection]? = nil, shops: [PreviewSection]? = nil, products: [ProductItem]? = nil) -> [Item] {
        
        var items = [Item]()
        if let malls = malls {
            items = malls.map {Item(mall: $0, shop: nil, popularProduct: nil)}
        } else if let shops = shops {
            items = shops.map {Item(mall: nil, shop: $0, popularProduct: nil)}
        } else if let products = products {
            items = products.map {Item(mall: nil, shop: nil, popularProduct: $0)}
        }
        return items
    }
    
    
    
}
