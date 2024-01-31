//
//  BuilderViewController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 30.01.24.
//
import UIKit

class BuilderViewController {
    
    static func buildMallController(gender: String, name: String) -> MallController {
        let path = "malls\(gender)"
        let mallService = MallService(path: path, keyField: "name", valueField: name, isArrayField: false)
        return MallController(modelInput: mallService, title: name, gender: gender)
    }

    static func buildListProductController(gender: String, shopName: String) -> ListProductController {
        let path = "products\(gender)"
        let modelListController: ListProductModelInput = ListProductService(path: path, keyField: "shops", valueField: shopName, isArrayField: true)
        return ListProductController(modelInput: modelListController, title: shopName)
    }

    static func buildProductController(product: ProductItem) -> ProductController {
        return ProductController(product: product)
    }
    
    static func buildMapController(arrayPin: [Places]) -> MapController {
        let fullScreenMap = MapController(arrayPin: arrayPin)
        fullScreenMap.modalPresentationStyle = .fullScreen
        return fullScreenMap
    }
}
