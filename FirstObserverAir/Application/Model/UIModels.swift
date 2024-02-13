//
//  UIModels.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 10.12.23.
//

import Foundation


// MARK: All Controllers

enum StateDataSource {
    case firstDataUpdate
    case followingDataUpdate
}

enum StateCancelShowErrorAlert {
    case segmentControlFailed
    case switchGenderFailed
    case forcedUpdateDataFailed
}

// MARK: - HomeController


enum ListenerErrorState {
    case restartFetchCartProducts
    case restartObserveUser
}

enum NetworkError: Error {
    case failParsingJSON(String)
}

struct SectionModel: Hashable {
    let section: String
    var items: [Item]
}

struct Item: Hashable {
    let mall: PreviewSection?
    let shop: PreviewSection?
    let popularProduct: ProductItem?
}

struct PreviewSection: Hashable {
    let name: String?
    let refImage: String?
    /// floor должен быть String для previewMall
    let logo: String?
    let floor: String?
    let priorityIndex:Int?
    init(dict: [String: Any]) {
        name = dict["name"] as? String
        refImage = dict["refImage"] as? String
        logo = dict["logo"] as? String
        floor = dict["floor"] as? String
        priorityIndex = dict["priorityIndex"] as? Int
    }
}


struct ProductItem: Hashable {
    let brand: String?
    let model: String?
    let category: String?
    let priorityIndex: Int?
    let strengthIndex: Int?
    let season: String?
    let color: String?
    let material: String?
    let description: String?
    let price: Int?
    let refImage: [String]?
    let shops: [String]?
    let originalContent: String?
    let gender: String?
    init(dict: [String: Any]) {
        brand = dict["brand"] as? String
        model = dict["model"] as? String
        category = dict["category"] as? String
        priorityIndex = dict["priorityIndex"] as? Int
        strengthIndex = dict["strengthIndex"] as? Int
        season = dict["season"] as? String
        color = dict["color"] as? String
        material = dict["material"] as? String
        description = dict["description"] as? String
        price = dict["price"] as? Int
        refImage = dict["refImage"] as? [String]
        shops = dict["shops"] as? [String]
        originalContent = dict["originalContent"] as? String
        gender = dict["gender"] as? String
    }
}

struct Shop {
    var name:String?
    var mall:String?
    var floor:String?
    var refImage:String?
    var telefon:String?
    var webSite:String?
    var logo:String?
    init(dict: [String: Any]) {
        name = dict["name"] as? String
        mall = dict["mall"] as? String
        floor = dict["floor"] as? String
        refImage = dict["refImage"] as? String
        telefon = dict["telefon"] as? String
        webSite = dict["webSite"] as? String
        logo = dict["logo"] as? String
    }
}

struct Pin {
    
    let name:String?
    let refImage:String?
    let address:String?
    let typeMall:String?
    let latitude:Double?
    let longitude:Double?
    init(dict: [String: Any]) {
        name = dict["name"] as? String
        refImage = dict["refImage"] as? String
        address = dict["address"] as? String
        typeMall = dict["typeMall"] as? String
        latitude = dict["latitude"] as? Double
        longitude = dict["longitude"] as? Double
    }
}

struct Mall {
    
    let name: String?
    let description: String?
    let floorPlan: String?
    let webSite: String?
    let priorityIndex: Int?
    let refImage: [String]?
    init(dict: [String: Any]) {
        self.name = dict["name"] as? String
        self.description = dict["description"] as? String
        self.floorPlan = dict["floorPlan"] as? String
        self.webSite = dict["webSite"] as? String
        self.priorityIndex = dict["priorityIndex"] as? Int
        self.refImage = dict["refImage"] as? [String]
    }
}






