//
//  CatalogController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 26.11.23.
//

import UIKit
import Firebase

//class CatalogController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = R.Colors.systemBackground
//    }
//
//}

// Протокол для обработки полученных данных
protocol CatalogModelOutput:AnyObject {
    func updateData(data: [PreviewSection]?, error: Error?)
}

class CatalogController: UIViewController {

    private var catalogModel: CatalogModelInput?
    private var stateDataSource: StateDataSource = .firstDataUpdate
    private var stateCancelAlert: StateCancelShowErrorAlert = .switchGenderFailed
    
    var dataSource:[PreviewSection] = [] {
        didSet {
//            collectionView.reloadData(data: dataSource, gender: homeModel?.returnLocalGender() ?? "Woman")
        }
    }
    
    var navController: NavigationController? {
            return self.navigationController as? NavigationController
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
}

// MARK: - Setting Views
private extension CatalogController {
    
    func setupView() {
        title = "Catalog"
        view.backgroundColor = R.Colors.systemBackground
        catalogModel = CatalogFirebaseService(output: self)
        checkConnectionAndSetupModel()
        setupCollectionView()
    }
}

// MARK: - Setting
private extension CatalogController {
    
    func setupCollectionView() {
        
    }
    
    func startLoadFirst() {
        startSpiner()
        setUserInteraction(false)
    }
    
    func startLoadFollowing() {
        startSpiner()
        setViewUserInteraction(false)
    }
    
    func stopLoad() {
        stopSpiner()
        setUserInteraction(true)
    }
    
    func startSpiner() {
        navController?.startSpinnerForWindow()
    }
    
    func stopSpiner() {
        navController?.stopSpinner()
    }
}

// MARK: - Setting DataSource
private extension CatalogController {
    
    func checkConnectionAndSetupModel() {
        
        if NetworkMonitor.shared.isConnected {
            print("NetworkMonitor.shared.isConnected")
            navController?.hiddenPlaceholder()
            firstFetchGenderData()
        } else {
            navController?.showPlaceholder()
            showErrorAlert(message: "No internet connection!", state: .followingDataUpdate) {
                // Повторно проверяем подключение, когда вызывается блок в showErrorAlert
                self.checkConnectionAndSetupModel()
            }
        }
    }
    
    func switchGender() {
        catalogModel?.isSwitchGender(completion: {
            self.catalogModel?.updateLocalGender()
            self.catalogModel?.fetchGenderData()
        })
    }
    
    func firstFetchGenderData() {
        startLoadFirst()
        catalogModel?.fetchGenderData()
    }
    
    func forceFetchGenderData() {
        startLoadFollowing()
        catalogModel?.fetchGenderData()
    }
}


// MARK: - CatalogModelOutput
extension CatalogController:CatalogModelOutput {
    
    func updateData(data: [PreviewSection]?, error: Error?) {
        stopLoad()
        switch stateDataSource {
            
        case .firstDataUpdate:
            guard let data = data, error == nil else {
                navController?.showPlaceholder()
                showErrorAlert(message: error?.localizedDescription ?? "Something went wrong!", state: .followingDataUpdate) {
                    self.firstFetchGenderData()
                } cancelActionHandler: {
                    self.stateDataSource = .followingDataUpdate
                }
                return
            }
            navController?.hiddenPlaceholder()
            stateDataSource = .followingDataUpdate
            
            dataSource = data
            
        case .followingDataUpdate:
            guard let data = data, error == nil else {
                self.showErrorAlert(message: error?.localizedDescription ?? "Something went wrong!", state: stateDataSource) {
                    self.forceFetchGenderData()
                    /// в этом блоке мы проверяем откуда мы пришли с ошибкой и откатываемся назад
                } cancelActionHandler: {
                    /// При нажатии на cancel мы всегда теряем observer
                    /// Мы должны проверять в viewWillAppeare есть ли наблюдатель активный в массиве
                    /// Если да то мы выпоняем switchGender() иначе forceFetchGenderData()
                    
                    switch self.stateCancelAlert {
                        
                    case .segmentControlFailed:
//                        self.homeModel?.toggleGlobalAndLocalGender()
                        NotificationCenter.default.post(name: NSNotification.Name("SwitchSegmentControlNotification"), object: nil)
                        self.stateCancelAlert = .switchGenderFailed
                    case .switchGenderFailed:
//                        self.homeModel?.toggleLocalGender()
                        break
                    case .forcedUpdateDataFailed:
                        break
                    }
                }
                return
            }
            stateCancelAlert = .switchGenderFailed
            dataSource = data
        }
    }
    
    
}
