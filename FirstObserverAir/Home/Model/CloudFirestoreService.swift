//
//  CloudFirestoreService.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 11.12.23.
//

import Foundation

class PreviewCloudFirestoreService {
    
    
    func fetchPreviewSection(path: String, completion: @escaping ([PreviewSection]?, Error?) -> Void) {
        
        FirebaseService.shared.fetchCollection(for: path, sorted: true) { documents, error in
            guard let documents = documents, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let response = try FetchPreviewDataResponse(documents: documents)
                completion(response.items, nil)
            } catch {
                //                ManagerFB.shared.CrashlyticsMethod
                completion(nil, error)
            }
            
        }
    }
}

struct FetchPreviewDataResponse {
    typealias JSON = [String : Any]
    let items:[PreviewSection]
    
    // мы можем сделать init не просто Failable а сделаем его throws
    // throws что бы он выдавал какие то ошибки если что то не получается
    init(documents: Any) throws {
        // если мы не сможем получить array то мы выплюним ошибку throw
        guard let array = documents as? [JSON] else { throw NetworkError.failParsingJSON("Failed to parse JSON")
        }
        
        var items = [PreviewSection]()
        for dictionary in array {
            // если у нас не получился comment то просто продолжаем - continue
            // потому что тут целый массив и малали один не получился остальные получаться
            let item = PreviewSection(dict: dictionary)
            items.append(item)
        }
        items.forEach { item in
            print("item - \(item.priorityIndex)")
        }
        self.items = items
    }
}

class ProductCloudFirestoreService {
   
    
    func fetchProducts(path: String, completion: @escaping ([ProductItem]?, Error?) -> Void) {
        
        FirebaseService.shared.fetchCollection(for: path, sorted: true) { documents, error in
            guard let documents = documents, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let response = try FetchProductsDataResponse(documents: documents)
                completion(response.items, nil)
            } catch {
//                ManagerFB.shared.CrashlyticsMethod
                completion(nil, error)
            }
            
        }
    }
}



struct FetchProductsDataResponse {
    typealias JSON = [String : Any]
    let items:[ProductItem]
    
    // мы можем сделать init не просто Failable а сделаем его throws
    // throws что бы он выдавал какие то ошибки если что то не получается
    init(documents: Any) throws {
        // если мы не сможем получить array то мы выплюним ошибку throw
        guard let array = documents as? [JSON] else { throw NetworkError.failParsingJSON("Failed to parse JSON")
        }
//        HomeScreenCloudFirestoreService.
        var items = [ProductItem]()
        for dictionary in array {
            // если у нас не получился comment то просто продолжаем - continue
            // потому что тут целый массив и малали один не получился остальные получаться
            let item = ProductItem(dict: dictionary)
            items.append(item)
        }
        self.items = items
    }
}

class ShopsCloudFirestoreService {
    
    func fetchShops(path: String, completion: @escaping ([Shop]?, Error?) -> Void) {
        
        FirebaseService.shared.fetchCollection(for: path) { documents, error in
//            print("fetchShops - \(String(describing: documents))")
            guard let documents = documents, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                
                let response = try FetchShopDataResponse(documents: documents)
                completion(response.items, nil)
            } catch {
//                ManagerFB.shared.CrashlyticsMethod
                completion(nil, error)
            }
            
        }
    }
}

struct FetchShopDataResponse {
    typealias JSON = [String : Any]
    let items:[Shop]
    
    // мы можем сделать init не просто Failable а сделаем его throws
    // throws что бы он выдавал какие то ошибки если что то не получается
    init(documents: Any) throws {
        // если мы не сможем получить array то мы выплюним ошибку throw
        guard let array = documents as? [JSON] else { throw NetworkError.failParsingJSON("Failed to parse JSON")
        }
        
        var items = [Shop]()
        for dictionary in array {
            // если у нас не получился comment то просто продолжаем - continue
            // потому что тут целый массив и малали один не получился остальные получаться
            let item = Shop(dict: dictionary)
            items.append(item)
        }
        self.items = items
    }
}

class PinCloudFirestoreService {
    
    func fetchPin(path: String, completion: @escaping ([Pin]?, Error?) -> Void) {
        
        FirebaseService.shared.fetchCollection(for: path) { documents, error in
            guard let documents = documents, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let response = try FetchPinDataResponse(documents: documents)
                completion(response.items, nil)
            } catch {
//                ManagerFB.shared.CrashlyticsMethod
                completion(nil, error)
            }
            
        }
    }
}

struct FetchPinDataResponse {
    typealias JSON = [String : Any]
    let items:[Pin]
    
    // мы можем сделать init не просто Failable а сделаем его throws
    // throws что бы он выдавал какие то ошибки если что то не получается
    init(documents: Any) throws {
        // если мы не сможем получить array то мы выплюним ошибку throw
        guard let array = documents as? [JSON] else { throw NetworkError.failParsingJSON("Failed to parse JSON")
        }
        
        var items = [Pin]()
        for dictionary in array {
            // если у нас не получился comment то просто продолжаем - continue
            // потому что тут целый массив и малали один не получился остальные получаться
            let item = Pin(dict: dictionary)
            items.append(item)
        }
        self.items = items
    }
}
