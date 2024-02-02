//
//  MallsFirebaseService.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 1.02.24.
//


import Foundation

// Протокол для модели данных
protocol CatalogModelInput: AnyObject {
    //    func isEmptyPathsGenderListener() -> Bool
    //    func toggleLocalGender()
    //    func toggleGlobalAndLocalGender()
    //    func returnLocalGender() -> String
    //    func setGlobalGender(gender:String)
    func deleteGenderListeners()
    func updateLocalGender()
    func fetchGenderData()
    func isSwitchGender(completion: @escaping () -> Void)
    
}

class CatalogFirebaseService {
    
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

extension CatalogFirebaseService: CatalogModelInput {
    
    func deleteGenderListeners() {
        removeGenderListeners()
        pathsGenderListener = []
    }
    
    func updateLocalGender() {
        gender = serviceFB.currentGender
    }
    
    func fetchGenderData() {
        deleteGenderListeners()
        pathsGenderListener.append("previewCatalog\(serviceFB.currentGender)")
        previewService.fetchPreviewSection(path: "previewCatalog\(serviceFB.currentGender)") { [weak self] (catalog, error) in
            guard let self = self else { return }
            
            guard let _ = self.localData["Catalog"] else {
                if let catalog = catalog, error == nil {
                    self.localData["Catalog"] = catalog
                }
                self.output?.updateData(data: catalog, error: error)
                return
            }
            
            guard let catalog = catalog, error == nil else {
                return
            }
            self.output?.updateData(data: catalog, error: error)
        }
    }
    
    func isSwitchGender(completion: @escaping () -> Void) {
        print("")
    }
    
    
}
