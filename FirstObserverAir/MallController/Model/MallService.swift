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
    func fetchMall(completion: @escaping (Mall?,[SectionModel]?,[Pin]?, Error?) -> Void)
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
        print("deinit MallService")
    }
}

private extension MallService {
    
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
    
    func fetchDataCollectionView(_ mall :Mall?) -> [SectionModel] {
        let shops = self.fetchShops(mallName: mall?.name ?? "")
        
        var dataCollectionView :[SectionModel] = []
        
        let itemsMall: [Item] = mall?.refImage?.map { refImage in
            let previewSection = PreviewSection(dict: ["refImage": refImage])
            return Item(mall: previewSection, shop: nil, popularProduct: nil)
        } ?? []
        let mallSection = SectionModel(section: "Mall", items: itemsMall)
        dataCollectionView.append(mallSection)
        
        let itemsShop: [Item] = shops.map { shop in
            let previewSection = PreviewSection(dict: ["name": shop.name ?? "", "refImage": shop.refImage ?? "", "floor": shop.floor ?? ""])
            return Item(mall: nil, shop: previewSection, popularProduct: nil)
        }
        let shopSection = SectionModel(section: "Shop", items: itemsShop)
        dataCollectionView.append(shopSection)
        
        return dataCollectionView
    }
}

extension MallService: MallModelInput {
    func fetchMall(completion: @escaping (Mall?, [SectionModel]?, [Pin]?, Error?) -> Void) {
        serviceFB.fetchCollectionFiltered(for: path, isArrayField: isArrayField, keyField: keyField, valueField: valueField) {[weak self] (documents, error) in
            guard let self = self else { return }
            guard let documents = documents, error == nil else {
                completion(nil,nil,nil,error)
                return
            }
            
            do {
                let response = try FetchMallDataResponse(documents: documents)
                let mall = response.items.first
                let pins = self.fetchPinMall(mallName: mall?.name ?? "")
                let dataCollectionView = self.fetchDataCollectionView(mall)
                completion(mall,dataCollectionView,pins,nil)
            } catch {
                print("Returned message for analytic FB Crashlytics error FirebaseService")
                completion(nil,nil,nil,error)
            }
        }
    }
}

