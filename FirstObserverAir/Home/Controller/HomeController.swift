//
//  HomeController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 26.11.23.
//

import UIKit

// Протокол для обработки полученных данных
protocol HomeModelOutput:AnyObject {
    func updateData(data: [String:SectionModel]?, error: Error?)
}

final class HomeController: UIViewController {

    private var homeModel: HomeModelInput?
    
    var navController: NavigationController? {
            return self.navigationController as? NavigationController
        }
    private var collectionView:HomeCollectionView!
    
    var stateDataSource: StateDataSource = .firstDataUpdate
    var dataSource:[SectionModel] = [] {
        didSet {
            collectionView.reloadData(data: dataSource, gender: homeModel?.returnGender() ?? "Woman")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switchGender()
        /// можно переместить его во viewDidLoad
        NotificationCenter.default.addObserver(self, selector: #selector(handleFailedFetchPersonalDataNotification(_:)), name: NSNotification.Name("FailedFetchPersonalDataNotification"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /// можно переместить его в updateData
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("FailedFetchPersonalDataNotification"), object: nil)
    }
}


// MARK: - Selectors
private extension HomeController {
    @objc func handleFailedFetchPersonalDataNotification(_ notification: NSNotification) {
        stopLoad()
        if let userInfo = notification.userInfo,
           let error = userInfo["error"] as? NSError,
           let enumValue = userInfo["enumValue"] as? ListenerErrorState {
            showErrorAlert(message: error.localizedDescription, state: self.stateDataSource) {
                self.startLoad()
                switch enumValue {
                    
                case .restartFetchCartProducts:
                    self.homeModel?.restartFetchCartProducts()
                case .restartObserveUser:
                    self.homeModel?.observeUserAndCardProducts()
                }
            }
        }
    }
}

// MARK: - Setting Views
private extension HomeController {
    
    func setupView() {
        view.backgroundColor = R.Colors.systemBackground
        homeModel = HomeFirebaseService(output: self)
        checkConnectionAndSetupModel()
        setupCollectionView()
        
//        tabBarController?.view.isUserInteractionEnabled = false
        title = "Observer"
//        navigationController?.navigationBar.prefersLargeTitles = true
    }
}



// MARK: - Setting DataSource
private extension HomeController {
    
    func checkConnectionAndSetupModel() {
        
        if NetworkMonitor.shared.isConnected {
            navController?.hiddenPlaceholder()
            fetchDataAndUser()
        } else {
            navController?.showPlaceholder()
            showErrorAlert(message: "No internet connection!", state: stateDataSource) {
                // Повторно проверяем подключение, когда вызывается блок в showErrorAlert
                self.checkConnectionAndSetupModel()
            }
        }
    }
    
    func fetchDataAndUser() {
        startLoad()
        homeModel?.observeUserAndCardProducts()
    }
    
    func switchGender() {
        homeModel?.isSwitchGender(completion: {
            self.homeModel?.updateModelGender()
            self.forceFetchGenderData()
        })
    }
    
    func forceFetchGenderData() {
        startLoad()
        homeModel?.fetchGenderData()
    }
    
    func forceFirstFetchData() {
        startLoad()
        homeModel?.firstFetchData()
    }
    
    func convertDictionaryToArray(data:[String : SectionModel]) -> [SectionModel] {
        let sortedDictionary = data.sorted { $0.key < $1.key }
        let array = Array(sortedDictionary.map({ $0.value }))
        return array
    }
}


// MARK: - Setting
private extension HomeController {
    func startLoad() {
        startSpiner()
        disableControls()
    }
    
    func stopLoad() {
        stopSpiner()
        enableControls()
    }
    
    func startSpiner() {
        navController?.startSpinnerForWindow()
    }
    
    func stopSpiner() {
        navController?.stopSpinner()
    }
    
    func disableControls() {
        // Отключите все элементы управления
        // Например, если у вас есть кнопка:
        // myButton.isEnabled = false
    }
    
    func enableControls() {
        // Включите все элементы управления
        // Например, если у вас есть кнопка:
        // myButton.isEnabled = true
    }
}

// MARK: - Setting CollectionView
private extension HomeController {
    func setupCollectionView() {
        collectionView = HomeCollectionView(gender: homeModel?.returnGender() ?? "Woman")
        collectionView.delegate = self
        collectionView.headerMallDelegate = self
        collectionView.headerShopDelegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        setupConstraintsCollectionView()
    }
}

// MARK: - Layout
private extension HomeController {
    func setupConstraintsCollectionView() {
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0), collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor), collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
    }
}

extension HomeController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("indexPath - \(indexPath.row)")
    }
}

// MARK: - HomeModelOutput
extension HomeController:HomeModelOutput {
    
    func updateData(data: [String:SectionModel]?, error: Error?) {
        
        stopLoad()
        
        switch self.stateDataSource {
            
        case .firstDataUpdate:
            guard let data = data, error == nil else {
                
                self.navController?.showPlaceholder()
                self.showErrorAlert(message: error?.localizedDescription ?? "Something went wrong!", state: self.stateDataSource) {
                    self.forceFirstFetchData()
                }
                return
            }
            self.navController?.hiddenPlaceholder()
            self.stateDataSource = .followingDataUpdate
            
            self.dataSource = self.convertDictionaryToArray(data: data)
            
        case .followingDataUpdate:
            guard let data = data, error == nil else {
                self.showErrorAlert(message: error?.localizedDescription ?? "Something went wrong!", state: self.stateDataSource) {
                    self.forceFetchGenderData()
                }
                return
            }
//            self.homeModel?.updateModelGender()
            self.dataSource = self.convertDictionaryToArray(data: data)
        }
    }
}
    

// MARK: - HeaderMallSectionDelegate
extension HomeController:HeaderMallSectionDelegate {
    func didSelectSegmentControl(gender: String) {
        homeModel?.setGender(gender: gender)
        switchGender()
    }
}

// MARK: - HeaderShopSectionDelegate
extension HomeController:HeaderShopSectionDelegate {
    func didSelectAllShopButton() {
        print("")
    }
}


    
    
    
    
    
    
    
    
