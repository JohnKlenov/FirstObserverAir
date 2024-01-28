//
//  HomeFirebaseService.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 11.12.23.
//

import Foundation

// Протокол для модели данных
protocol HomeModelInput: AnyObject {
    func toggleGender()
    func returnGender() -> String
    func fetchGenderData()
    func firstFetchData()
    func isSwitchGender(completion: @escaping () -> Void)
    func setGender(gender:String)
    func updateModelGender()
    func observeUserAndCardProducts()
    func restartFetchCartProducts()

}

class HomeFirebaseService {
    
    weak var output: HomeModelOutput?
    
    let serviceFB = FirebaseService.shared
    let semaphoreGender = DispatchSemaphore(value: 0)
    let semaphoreRelate = DispatchSemaphore(value: 0)
    
    lazy var pathsGenderListener = [String]()
    lazy var pathsRelatedListener = [String]()
    
    var dataHome:[String:SectionModel]? {
        didSet {
            if stateDataSource == .followingDataUpdate {
                DispatchQueue.main.async {
                    self.output?.updateData(data: self.dataHome, error: nil)
                }
            }
        }
    }
    lazy var firstErrors: [Error?] = []
    lazy var stateDataSource: StateDataSource = .firstDataUpdate
    lazy var isFirstStartSuccessful = false
    lazy var gender: String = ""
    
    let previewService = PreviewCloudFirestoreService()
    let productService = ProductCloudFirestoreService()
    let shopsService = ShopsCloudFirestoreService()
    let pinService = PinCloudFirestoreService()
    
    init(output: HomeModelOutput) {
        self.output = output
        updateModelGender()
        NotificationCenter.default.addObserver(self, selector: #selector(handleSuccessfulFetchPersonalDataNotification), name: NSNotification.Name("SuccessfulFetchPersonalDataNotification"), object: nil)
    }
    
    // help methods
    
    func createItem(malls: [PreviewSection]? = nil, shops: [PreviewSection]? = nil, products: [ProductItem]? = nil) -> [Item] {
        
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
    
    func removeGenderListeners() {
        pathsGenderListener.forEach { path in
            self.serviceFB.removeListeners(for: path)
        }
    }
    
    func removeRelatedListeners() {
        pathsRelatedListener.forEach { path in
            self.serviceFB.removeListeners(for: path)
        }
    }
    
    func deleteGenderListeners() {
        removeGenderListeners()
        pathsGenderListener = []
    }
    
    func deleteRelatedListeners() {
        removeRelatedListeners()
        pathsRelatedListener = []
    }
    
    func deleteAllListeners() {
        deleteGenderListeners()
        deleteRelatedListeners()
    }
    
    func returnFirstError(in errors: [Error?]) -> Error? {
        return errors.compactMap { $0 }.first
    }
}

extension HomeFirebaseService: HomeModelInput {
    
    func toggleGender() {
        if gender == "Man" {
            setGender(gender: "Woman")
            updateModelGender()
        } else {
            setGender(gender: "Man")
            updateModelGender()
        }
    }
    
    func returnGender() -> String {
        return gender
    }
    
    func restartFetchCartProducts() {
        serviceFB.fetchCartProducts()
    }
    
    func setGender(gender: String) {
        serviceFB.setGender(gender: gender)
    }
    
    func updateModelGender() {
        gender = serviceFB.currentGender
    }
    
    func isSwitchGender(completion: @escaping () -> Void) {
        if gender != serviceFB.currentGender {
            completion()
        }
    }
    
    @objc func handleSuccessfulFetchPersonalDataNotification(_ notification: NSNotification) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("SuccessfulFetchPersonalDataNotification"), object: nil)
        firstFetchData()
    }
    
    func firstFetchData() {
        stateDataSource = .firstDataUpdate
        DispatchQueue.global().async {
            self.fetchRelatedData()
            self.fetchGender()
        }
    }
    
    func fetchGenderData() {
        stateDataSource = .firstDataUpdate
        DispatchQueue.global().async {
            self.fetchGender()
        }
    }
    
    func fetchGender() {
            
        dataHome = [:]
        deleteGenderListeners()
        pathsGenderListener.append("previewMall\(gender)")
        previewService.fetchPreviewSection(path: "previewMall\(gender)") { malls, error in
            
            let items = self.createItem(malls: malls, shops: nil, products: nil)
            let mallSection = SectionModel(section: "Malls", items: items)
            
            guard let _ = self.dataHome?["A"] else {
                
                if let _ = malls, error == nil {
                    self.dataHome?["A"] = mallSection
                }
                self.firstErrors.append(error)
                self.semaphoreGender.signal()
                return
            }
            
            guard let _ = malls, error == nil else {
                return
            }
            self.dataHome?["A"] = mallSection
        }
        semaphoreGender.wait()
        
        pathsGenderListener.append("previewShops\(gender)")
        previewService.fetchPreviewSection(path: "previewShops\(gender)") { shops, error in
            
            let items = self.createItem(malls: nil, shops: shops, products: nil)
            let shopSection = SectionModel(section: "Shops", items: items)
            
            
            guard let _ = self.dataHome?["B"] else {
                
                if let _ = shops, error == nil {
                    self.dataHome?["B"] = shopSection
                }
                self.firstErrors.append(error)
                self.semaphoreGender.signal()
                return
            }
            guard let _ = shops, error == nil else {
                return
            }
            self.dataHome?["B"] = shopSection
        }
        semaphoreGender.wait()
        
        pathsGenderListener.append("popularProduct\(gender)")
        productService.fetchProducts(path: "popularProduct\(gender)") { products, error in
            
            let items = self.createItem(malls: nil, shops: nil, products: products)
            let productsSection = SectionModel(section: "PopularProducts", items: items)
            
            
            guard let _ = self.dataHome?["C"] else {
               
                if let _ = products, error == nil {
                    self.dataHome?["C"] = productsSection
                }
                self.firstErrors.append(error)
                self.semaphoreGender.signal()
                return
            }
            
            guard let _ = products, error == nil else {
                return
            }

            self.dataHome?["C"] = productsSection
        }
        semaphoreGender.wait()
        
        
        DispatchQueue.main.async {
            
            let firstError = self.returnFirstError(in: self.firstErrors)
            self.firstErrors.removeAll()
            
            guard self.dataHome?.count == 3, firstError == nil else {
                
                self.dataHome = nil
                self.output?.updateData(data: self.dataHome, error: firstError)
//                self.dataHome = nil
                /// при restartGender нельзя удалять всех наблюдателей!!!
                if self.stateDataSource == .firstDataUpdate, !self.isFirstStartSuccessful {
                    self.deleteAllListeners()
                } else {
                    self.deleteGenderListeners()
                }
                return
            }
            self.isFirstStartSuccessful = true
            self.stateDataSource = .followingDataUpdate
            self.output?.updateData(data: self.dataHome, error: firstError)
        }
    }
    
    func fetchRelatedData() {
        
        deleteRelatedListeners()
        
        pathsRelatedListener.append("shopsMan")
        shopsService.fetchShops(path: "shopsMan") { shopsMan, error in
            guard let _ = self.serviceFB.shops["Man"] else {
                if let shopsMan = shopsMan, error == nil {
                    self.serviceFB.shops["Man"] = shopsMan
                    self.serviceFB.shops["Woman"] = shopsMan
                }
                self.firstErrors.append(error)
                self.semaphoreRelate.signal()
                return
            }
            guard let shopsMan = shopsMan, error == nil else {
                return
            }
            self.serviceFB.shops["Woman"] = shopsMan
            self.serviceFB.shops["Man"] = shopsMan
        }
        semaphoreRelate.wait()
        
        /// shopsWoman отсутствует в БД временно
//        pathsRelatedListener.append("shopsWoman")
//        shopsService.fetchShops(path: "shopsWoman") { shopsWoman, error in
//
//            guard let _ = self.serviceFB.shops?["Woman"] else {
//                if let shopsWoman = shopsWoman, error == nil {
//                    self.serviceFB.shops?["Woman"] = shopsWoman
//                }
//                self.firstErrors.append(error)
//                self.semaphoreRelate.signal()
//                return
//            }
//            guard let shopsWoman = shopsWoman, error == nil else {
//                return
//            }
//
//            self.serviceFB.shops?["Woman"] = shopsWoman
//        }
//        semaphoreRelate.wait()
        
        pathsRelatedListener.append("pinMalls")
        pinService.fetchPin(path: "pinMalls") { pins, error in
            guard let _ = self.serviceFB.pinMall else {
                if let pins = pins, error == nil {
                    self.serviceFB.pinMall = pins
                }
                self.firstErrors.append(error)
                self.semaphoreRelate.signal()
                return
            }
            
            guard let pins = pins, error == nil else {
                return
            }
            self.serviceFB.pinMall = pins
        }
        semaphoreRelate.wait()
    }
    
    func observeUserAndCardProducts() {
        serviceFB.removeStateDidChangeListener()
        serviceFB.observeUserAndCardProducts()
    }
}
