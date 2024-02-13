//
//  MallsFirebaseService.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 1.02.24.
//


import Foundation

// Протокол для модели данных
protocol CatalogModelInput: AnyObject {
    
    func toggleLocalGender()
    func toggleGlobalAndLocalGender()
    func returnLocalGender() -> String
    func setGlobalGender(gender:String)
    func isEmptyPathsGenderListener() -> Bool
    func deleteGenderListeners()
    func updateLocalGender()
    func fetchGenderData()
    func isSwitchGender(completion: @escaping () -> Void)
}

final class CatalogFirebaseService {
    
    weak var output: CatalogModelOutput?
    private let serviceFB = FirebaseService.shared
    private let previewService = PreviewCloudFirestoreService()
    private lazy var pathsGenderListener = [String]()
    private lazy var gender: String = ""
    private var localData:[String:[PreviewSection]] = [:]
    
    init(output: CatalogModelOutput) {
        self.output = output
        updateLocalGender()
    }
    
    
    
    func removeGenderListeners() {
        pathsGenderListener.forEach { path in
            self.serviceFB.removeListeners(for: path)
        }
    }
}


// MARK: - CatalogModelInput
extension CatalogFirebaseService: CatalogModelInput {
    
    func returnLocalGender() -> String {
        return gender
    }
    
    func toggleLocalGender() {
        if gender == "Man" {
            gender = "Woman"
        } else {
            gender = "Man"
        }
    }
    
    func toggleGlobalAndLocalGender() {
        if gender == "Man" {
            setGlobalGender(gender: "Woman")
            updateLocalGender()
        } else {
            setGlobalGender(gender: "Man")
            updateLocalGender()
        }
    }
    
    func setGlobalGender(gender: String) {
        serviceFB.setGender(gender: gender)
    }
    
    func isEmptyPathsGenderListener() -> Bool {
        return pathsGenderListener.isEmpty
    }
    
    func deleteGenderListeners() {
        removeGenderListeners()
        pathsGenderListener = []
    }
    
    func updateLocalGender() {
        gender = serviceFB.currentGender
    }
    
    func fetchGenderData() {
        localData = [:]
        deleteGenderListeners()
        pathsGenderListener.append("previewCatalog\(serviceFB.currentGender)")
        previewService.fetchPreviewSection(path: "previewCatalog\(serviceFB.currentGender)") { [weak self] (catalog, error) in
            guard let self = self else { return }
            let items = ModelDataTransformation.createItem(malls: catalog, shops: nil, products: nil)
            guard let _ = self.localData["Catalog"] else {
                if let catalog = catalog, error == nil {
                    self.localData["Catalog"] = catalog
                }
                self.output?.updateData(data: items, error: error)
                return
            }
            
            guard let _ = catalog, error == nil else {
                return
            }
            self.output?.updateData(data: items, error: error)
        }
    }
    
    func isSwitchGender(completion: @escaping () -> Void) {
        if gender != serviceFB.currentGender {
            completion()
        }
    }
}
