//
//  MallService.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 20.01.24.
//

/// Places, MallModel, Shop
import Foundation

// Протокол для модели данных
protocol MallModelInput: AnyObject {
    func fetchMall(completion: @escaping ([Mall]?, Error?) -> Void)
}


final class MallService {
    
    let serviceFB = FirebaseService.shared
    
    private var path:String
    private var keyField:String
    private var valueField:String
    private var isArrayField:Bool
    
    
    init(path:String, keyField:String, valueField:String, isArrayField:Bool) {
        self.path = path
        self.keyField = keyField
        self.valueField = valueField
        self.isArrayField = isArrayField
    }
    
    deinit {
        print("deinit ListProductService")
    }
}

extension MallService {
    
    func fetchShops(mallName: String) -> [Shop] {
        let gender = serviceFB.currentGender
        guard let allShops = serviceFB.shops[gender] else {
            print("Returned message for analytic FB Crashlytics error MallFirebaseService func fetchShops(shopsProduct: [String]) -> [Shop]")
            return []
        }
        return allShops.filter{ $0.mall == mallName }
    }
    
    func fetchPinMall(mallName: String) -> [Pin] {
        guard let pinMall = serviceFB.pinMall else {
            print("Returned message for analytic FB Crashlytics error MallFirebaseService func fetchPinMall(shopsForProduct: [Shop]) -> [Pin]")
            return []
        }
        return pinMall.filter { $0.name == mallName }
    }
}

extension MallService: MallModelInput {
    func fetchMall(completion: @escaping ([Mall]?, Error?) -> Void) {
        serviceFB.fetchCollectionFiltered(for: path, isArrayField: isArrayField, keyField: keyField, valueField: valueField) { documents, error in
            guard let documents = documents, error == nil else {
                completion(nil, error)
                return
            }

            do {
                let response = try FetchMallDataResponse(documents: documents)
                completion(response.items, nil)
            } catch {
                print("Returned message for analytic FB Crashlytics error FirebaseService")
                completion(nil, error)
            }
        }
    }
}

