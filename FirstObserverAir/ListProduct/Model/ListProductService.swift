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
    
    private var path:String
    private var keyField:String?
    private var valueField:String
    private var isArrayField:Bool?
    
    
    init(path:String, keyField:String?, valueField:String, isArrayField:Bool?) {
        self.path = path
        self.keyField = keyField
        self.valueField = valueField
        self.isArrayField = isArrayField
    }
    
    deinit {
        print("deinit ListProductService")
    }
}

extension ListProductService: ListProductModelInput {
    func fetchProduct(completion: @escaping ([ProductItem]?, Error?) -> Void) {
        
        serviceFB.fetchCollectionFiltered(for: path, isArrayField: isArrayField, keyField: keyField, valueField: valueField) { documents, error in
            guard let documents = documents, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let response = try FetchProductsDataResponse(documents: documents)
                completion(response.items, nil)
            } catch {
                print("Returned message for analytic FB Crashlytics error FirebaseService")
                //                ManagerFB.shared.CrashlyticsMethod
                completion(nil, error)
            }
        }
    }
}
