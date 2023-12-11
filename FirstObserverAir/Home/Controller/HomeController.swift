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
    
    var stateDataSource: StateDataSource = .firstDataUpdate
    var dataSource:[String : SectionModel] = [:] {
        didSet {
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
        view.backgroundColor = .red
        homeModel = HomeFirebaseService(output: self)
        startLoad()
        homeModel?.firstFetchData()
//        checkConnectionAndSetupModel()
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
            self.dataSource = data
//            print test
            dataSource.forEach { key, value in
                print("##############################################################")
                print("\(value)")
            }
            
        case .followingDataUpdate:
            guard let data = data, error == nil else {
                self.showErrorAlert(message: error?.localizedDescription ?? "Something went wrong!", state: self.stateDataSource) {
                    self.forceFetchGenderData()
                }
                return
            }
            self.dataSource = data
            self.homeModel?.updateModelGender()
        }
    }
}
    
    
    
    
    
    
    
    
    
    
    
    
    //    let productService = ProductCloudFirestoreService()
    //        productService.fetchProducts(path: "popularProductMan") { products, error in
    //            guard error == nil else {
    //                print(error?.localizedDescription ?? "Error!!!")
    //                return
    //            }
    //
    //            let items = self.createItem(malls: nil, shops: nil, products: products)
    //            items.forEach { item in
    //                print("item - \(String(describing: item.popularProduct))")
    //            }
    //        }
            
//            if NetworkMonitor.shared.isConnected {
//               print(true)
//            } else {
//                print(false)
//            }
    //        navController?.showPlaceholder()
    //        navController?.startSpinnerForPlaceholder()
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    //            self.navController?.stopSpinner()
    //            self.navController?.hiddenPlaceholder()
    //        }
    
    //    // MARK: - helper methods
//
//    func createItem(malls: [PreviewSection]? = nil, shops: [PreviewSection]? = nil, products: [ProductItem]? = nil) -> [Item] {
//
//        var items = [Item]()
//        if let malls = malls {
//            items = malls.map {Item(mall: $0, shop: nil, popularProduct: nil)}
//        } else if let shops = shops {
//            items = shops.map {Item(mall: nil, shop: $0, popularProduct: nil)}
//        } else if let products = products {
//            items = products.map {Item(mall: nil, shop: nil, popularProduct: $0)}
//        }
//        return items
//    }
//}



//struct FetchProductsDataResponse {
//    typealias JSON = [String : Any]
//    let items:[ProductItem]
//
//    // мы можем сделать init не просто Failable а сделаем его throws
//    // throws что бы он выдавал какие то ошибки если что то не получается
//    init(documents: Any) throws {
//        // если мы не сможем получить array то мы выплюним ошибку throw
//        guard let array = documents as? [JSON] else { throw NetworkError.failParsingJSON("Failed to parse JSON")
//        }
////        HomeScreenCloudFirestoreService.
//        var items = [ProductItem]()
//        for dictionary in array {
//            // если у нас не получился comment то просто продолжаем - continue
//            // потому что тут целый массив и малали один не получился остальные получаться
//            let item = ProductItem(dict: dictionary)
//            items.append(item)
//        }
//        self.items = items
//    }
//}
//
//
//class ProductCloudFirestoreService {
//
//
//    func fetchProducts(path: String, completion: @escaping ([ProductItem]?, Error?) -> Void) {
//
//        FirebaseService.shared.fetchStartCollection(for: path) { documents, error in
//            guard let documents = documents, error == nil else {
//                completion(nil, error)
//                return
//            }
//
//            do {
//                let response = try FetchProductsDataResponse(documents: documents)
//                completion(response.items, nil)
//            } catch {
////                ManagerFB.shared.CrashlyticsMethod
//                completion(nil, error)
//            }
//
//        }
//    }
//
////    static func removeListeners(for path: String) {
////        ManagerFB.shared.removeListeners(for: path)
////    }
//}
