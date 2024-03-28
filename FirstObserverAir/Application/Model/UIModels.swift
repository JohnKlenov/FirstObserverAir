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
    let isNotAvailoble: Bool?
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
        isNotAvailoble = dict["isNotAvailoble"] as? Bool
    }
    
    var dictionaryRepresentation: [String: Any] {
        return [
            "brand": brand as Any,
            "model": model as Any,
            "category": category as Any,
            "priorityIndex": priorityIndex as Any,
            "strengthIndex": strengthIndex as Any,
            "season": season as Any,
            "color": color as Any,
            "material": material as Any,
            "description": description as Any,
            "price": price as Any,
            "refImage": refImage as Any,
            "shops": shops as Any,
            "originalContent": originalContent as Any,
            "gender": gender as Any,
            "isNotAvailoble": isNotAvailoble as Any
        ]
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

enum AuthErrorCodeState {
    // Добавьте свойства для кода ошибки и сообщения об ошибке
    case success
    case failed(String)
    case invalidUserToken(String)
    case userTokenExpired(String)
    case userMismatch(String)
    case requiresRecentLogin(String)
    case keychainError(String)
    /// проблемы с сетью.
    case networkError(String)
    ///адрес электронной почты не связан с каким-либо аккаунтом.
    case userNotFound(String)
    case wrongPassword(String)
    ///слишком много запросов к серверу в короткий промежуток времени.
    case tooManyRequests(String)
    case expiredActionCode(String)
    ///“Предоставленные учетные данные недействительны. Пожалуйста, проверьте свои данные и попробуйте снова.”
    case invalidCredential(String)
    ///в запросе был отправлен недействительный адрес электронной почты получателя.
    case invalidRecipientEmail(String)
    case missingEmail(String)
    ///не соответствует формату стандартного адреса электронной почты.
    case invalidEmail(String)
    case providerAlreadyLinked(String)
    case credentialAlreadyInUse(String)
    case userDisabled(String)
    case emailAlreadyInUse(String)
    case weakPassword(String)
    ///в консоли для этого действия установлен недействительный адрес электронной почты отправителя.
    case invalidSender(String)
    case accountExistsWithDifferentCredential(String)
//    ///был указан недействительный шаблон электронной почты для отправки обновления.
//    case invalidMessagePayload(String)
}

enum StorageErrorCodeState {
    case unauthenticated(String)
    case retryLimitExceeded(String)
}





