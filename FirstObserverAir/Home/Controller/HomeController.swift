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
        setBackButtonWithoutTitle("")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let isAnimating = navController?.isAnimatingSpiner(), isAnimating {
            print("spiner animating")
//            stopLoad()
        }
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
                self.startLoadFirst()
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
        title = "Observer"
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
        startLoadFirst()
        homeModel?.observeUserAndCardProducts()
    }
    
    func switchGender() {
        homeModel?.isSwitchGender(completion: {
            self.homeModel?.updateModelGender()
            self.forceFetchGenderData()
        })
    }
    
    func forceFetchGenderData() {
        startLoadFollowing()
        homeModel?.fetchGenderData()
    }
    
    func forceFirstFetchData() {
        startLoadFirst()
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
        print("indexPath - \(indexPath.section)")
        switch indexPath.section {
        case 0:
            print("0")
        case 1:
            print("1")
            let gender = homeModel?.returnGender() ?? ""
            let path = "products\(gender)"
            let valueField = dataSource[indexPath.section].items[indexPath.row].shop?.name ?? ""
            let modelListController: ListProductModelInput = ListProductService(path: path, keyField: "shops", valueField: valueField, isArrayField: true)
            let shopProductVC = ListProductController(modelInput: modelListController, title: valueField)
//            let shopProductVC = ListProductController(path: "", keyField: "", valueField: "", isArrayField: true, title: "")
            navigationController?.pushViewController(shopProductVC, animated: true)
        case 2:
            print("2")
            if let product = dataSource[indexPath.section].items[indexPath.row].popularProduct {
                let productVC = ProductController(product: product)
                navigationController?.pushViewController(productVC, animated: true)
            }
        default:
            print("default")
        }
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

// Home if pressed cancel -> togle gender for modal and root property(возвращаем все как было) + segment(switch)
// Mall -> Если мы уже init Mall in viewWillAppear switchGender() + homeModel?.isSwitchGender(completion) не срабатывает и обновление данных не происходит
// Mall -> Если мы не init Mall -> in viewDidLoad init MallModel(self) + init() { updateModelGender() } -> fetch data failed
// Mall -> first fetch data failed -> create placeholder for rootView с btn Try! (выставляем флаг в viewWillAppear и при новом переходе снова fetch data)

// Home didSelectSegmentControl -> homeModel?.setGender(gender: gender)(root) -> func switchGender() + self.homeModel?.updateModelGender() = semgment switch (Man)
// if error -> cancel переходим на другой item(VC) ->
// Mall item(VC) -> func switchGender() + self.homeModel?.updateModelGender() -> forceFetchGenderData() semgment not switch (Woman)
// if error -> cancel переходим на другой item(VC) ->
// Catalog tem(VC) -> func switchGender() + self.homeModel?.updateModelGender() -> forceFetchGenderData() semgment switch (Man) !!!Success

// back  Mall item(VC) -> func switchGender() -> не срабатывает forceFetchGenderData() segment Woman контент Man

// MARK: - HeaderShopSectionDelegate
extension HomeController:HeaderShopSectionDelegate {
    func didSelectAllShopButton() {
        let allShops = AllShopsController(shops: dataSource[1])
        navigationController?.pushViewController(allShops, animated: true)
    }
}


    
    
    
    
    
    
    
    
