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
    
    private var stateDataSource: StateDataSource = .firstDataUpdate
    private var stateCancelAlert: StateCancelShowErrorAlert = .switchGenderFailed
    
    var dataSource:[SectionModel] = [] {
        didSet {
            collectionView.reloadData(data: dataSource, gender: homeModel?.returnLocalGender() ?? "Woman")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        //         navigationItem.setHidesBackButton(true, animated: true) - скрывает BackButton
        setBackButtonWithoutTitle("")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let isAnimating = navController?.isAnimatingSpiner(), isAnimating {
            print("spiner animating")
//            stopLoad()
        }
        
        if let isEmpty = homeModel?.isEmptyPathsGenderListener(), isEmpty, stateDataSource == .followingDataUpdate {
            stateCancelAlert = .forcedUpdateDataFailed
            forceFetchGenderData()
        } else {
            switchGender()
        }
        
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
//                self.startLoadFirst()
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
        title = "Observer"
        view.backgroundColor = R.Colors.systemBackground
        homeModel = HomeFirebaseService(output: self)
        checkConnectionAndSetupModel()
        setupCollectionView()
//        navigationController?.navigationBar.prefersLargeTitles = true
    }
}



// MARK: - Setting DataSource
private extension HomeController {
    
    func checkConnectionAndSetupModel() {
        
        if NetworkMonitor.shared.isConnected {
            print("NetworkMonitor.shared.isConnected")
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
//        startLoadFirst()
        startLoad()
        homeModel?.observeUserAndCardProducts()
    }
    
    func switchGender() {
        homeModel?.isSwitchGender(completion: {
            self.homeModel?.updateLocalGender()
            self.forceFetchGenderData()
        })
    }
    
    func forceFetchGenderData() {
//        startLoadFollowing()
        startLoad()
        homeModel?.fetchGenderData()
    }
    
    func forceFirstFetchData() {
//        startLoadFirst()
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
    
//    func startLoadFirst() {
//        startSpiner()
//        /// возможно имеет смысл блокировать везде через setUserInteraction(false)
//        setUserInteraction(false)
//    }
//
//    func startLoadFollowing() {
//        startSpiner()
//        setViewUserInteraction(false)
//    }
    
    func startLoad() {
        startSpiner()
        setUserInteraction(false)
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

// MARK: - Setting CollectionView
private extension HomeController {
    func setupCollectionView() {
        collectionView = HomeCollectionView(gender: homeModel?.returnLocalGender() ?? "Woman")
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
        let gender = homeModel?.returnLocalGender() ?? ""
        switch indexPath.section {
        case 0:
            let valueField = dataSource[indexPath.section].items[indexPath.row].mall?.name ?? ""
            let mallController = BuilderViewController.buildMallController(gender: gender, name: valueField)
            navigationController?.pushViewController(mallController, animated: true)
        case 1:
            let valueField = dataSource[indexPath.section].items[indexPath.row].shop?.name ?? ""
            let shopProductVC = BuilderViewController.buildListProductController(gender: gender, keyField: "shops", valueField: valueField, isArrayField: true)
            navigationController?.pushViewController(shopProductVC, animated: true)
        case 2:
            if let product = dataSource[indexPath.section].items[indexPath.row].popularProduct {
                let productVC = BuilderViewController.buildProductController(product: product)
                navigationController?.pushViewController(productVC, animated: true)
            }
        default:
            break
        }
    }
}

// MARK: - HomeModelOutput
extension HomeController:HomeModelOutput {
    
    func updateData(data: [String:SectionModel]?, error: Error?) {
        
        stopLoad()
        switch stateDataSource {
            
        case .firstDataUpdate:
            guard let data = data, error == nil else {
                navController?.showPlaceholder()
                showErrorAlert(message: error?.localizedDescription ?? "Something went wrong!", state: stateDataSource) {
                    self.forceFirstFetchData()
                }
                return
            }
            navController?.hiddenPlaceholder()
            stateDataSource = .followingDataUpdate
            
            dataSource = convertDictionaryToArray(data: data)
            
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
                        self.homeModel?.toggleGlobalAndLocalGender()
                        NotificationCenter.default.post(name: NSNotification.Name("SwitchSegmentControlHeaderMallNotification"), object: nil)
                        self.stateCancelAlert = .switchGenderFailed
                    case .switchGenderFailed:
                        self.homeModel?.toggleLocalGender()
                    case .forcedUpdateDataFailed:
                        break
                    }
                }
                return
            }
            stateCancelAlert = .switchGenderFailed
            dataSource = convertDictionaryToArray(data: data)
        }
    }
}
    
// MARK: - HeaderMallSectionDelegate
extension HomeController:HeaderMallSectionDelegate {
    func didTapAllMallButton() {
        print("didTapAllMallButton")
    }
    
    func didSelectSegmentControl(gender: String) {
        stateCancelAlert = .segmentControlFailed
        homeModel?.setGlobalGender(gender: gender)
        switchGender()
    }
}

// MARK: - HeaderShopSectionDelegate
extension HomeController:HeaderShopSectionDelegate {
    func didSelectAllShopButton() {
        let gender = homeModel?.returnLocalGender() ?? ""
        let allShops = AllShopsController(shops: dataSource[1], currentGender: gender)
        navigationController?.pushViewController(allShops, animated: true)
    }
}
