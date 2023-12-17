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
//        startLoad()
//        homeModel?.firstFetchData()
        checkConnectionAndSetupModel()
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
    
    
    
    
//extension AbstractHomeViewController:HeaderSegmentedControlViewDelegate {
//    func didSelectSegmentControl(gender: String) {
//        homeModel?.setGender(gender: gender)
//        switchGender()
//    }
//}
//
//// view
//
//protocol HeaderSegmentedControlViewDelegate: AnyObject {
//    func didSelectSegmentControl(gender:String)
//}
//
//class HeaderSegmentedControlView: UICollectionReusableView {
//    weak var delegate: HeaderSegmentedControlViewDelegate?
//
//    func configureCell(title: String, gender:String) {
//        //        segmentedControl.selectedSegmentIndex = gender == "Woman" ? 0 : 1
//        //        label.text = title
//    }
//
//    @objc func didTapSegmentedControl(_ segmentControl: UISegmentedControl) {
//        switch segmentControl.selectedSegmentIndex {
//        case 0:
//            delegate?.didSelectSegmentControl(gender: "Woman")
//        case 1:
//            delegate?.didSelectSegmentControl(gender: "Man")
//        default:
//            break
//        }
//    }
//
//}
    
    
    
    
    
    
    
    
