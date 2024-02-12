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
    
    /// тут мы подаем значения по которому будем фильтровать массив и возвращаем отфильтрованный.
    static func filterProductsUniversal(products: [ProductItem], color: [String]? = nil, brand: [String]? = nil, material: [String]? = nil, season: [String]? = nil, minPrice: Int? = nil, maxPrice: Int? = nil) -> [ProductItem] {
        let filteredProducts = products.filter { product in
            var isMatched = true

            if let color = color {
                isMatched = isMatched && color.contains(product.color ?? "")
            }

            if let brand = brand {
                isMatched = isMatched && brand.contains(product.brand ?? "")
            }

            if let material = material {
                isMatched = isMatched && material.contains(product.material ?? "")
            }

            if let season = season {
                isMatched = isMatched && season.contains(product.season ?? "")
            }

            if let minPrice = minPrice {
                isMatched = isMatched && (product.price ?? -1 >= minPrice)
            }

            if let maxPrice = maxPrice {
                isMatched = isMatched && (product.price ?? 1000 <= maxPrice)
            }

            return isMatched
        }

        return filteredProducts
    }
    
    /// тут мы из selectedItem по indexPath.section собираем все tagy для фильтрации продуктов
    /// то есть ищем все критерии фильтрации что мы выбрали для всех категориий - Color, Brand, Material ..
    /// затем подаем их на filterProductsUniversal и получаем массив отфильтрованных продуктов.
    static func extractValues(from selectedItem: [IndexPath : String]) -> (season: [Dictionary<IndexPath, String>.Values.Element]?, material: [Dictionary<IndexPath, String>.Values.Element]?, brand: [Dictionary<IndexPath, String>.Values.Element]?, color: [Dictionary<IndexPath, String>.Values.Element]?) {
        let filteredColor = Array(selectedItem.filter { $0.key.section == 0 }.values)
        let color = filteredColor.isEmpty ? nil : filteredColor
        
        let filteredBrand = Array(selectedItem.filter { $0.key.section == 1 }.values)
        let brand = filteredBrand.isEmpty ? nil : filteredBrand
        
        let filteredMaterial = Array(selectedItem.filter { $0.key.section == 2 }.values)
        let material = filteredMaterial.isEmpty ? nil : filteredMaterial
        
        let filteredSeason = Array(selectedItem.filter { $0.key.section == 3 }.values)
        let season = filteredSeason.isEmpty ? nil : filteredSeason
        
        return (season, material, brand, color)
    }
    
    
}
