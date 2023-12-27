//
//  ListProductController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 27.12.23.
//

import UIKit

final class ListProductController: UIViewController {
    
    private var dataSource:[ProductItem] = [] {
        didSet {
            
        }
    }
    
    private var listProductModel: ListProductModelInput
    private var navController: NavigationController? {
            return self.navigationController as? NavigationController
        }
    private var collectionView:HomeCollectionView!
    
    init(modelInput: ListProductModelInput) {
        self.listProductModel = modelInput
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Setting DataSource
private extension ListProductController {
    func fetchProduct() {
        startLoad()
        listProductModel.fetchProduct { products, error in
            self.stopLoad()
            guard let products = products, error == nil else {
                self.showErrorAlert(message: error?.localizedDescription ?? "Something went wrong!", state: .followingDataUpdate) {
                    self.fetchProduct()
                } cancelActionHandler: {
                    print("BackNC")
                }
                return
            }
            self.dataSource = products
        }
    }
}

// MARK: - Setting Views
private extension ListProductController {
    
    func setupView() {
    }
}

// MARK: - Setting
private extension ListProductController {
    func startLoad() {
        startSpiner()
        disableControls()
    }
    
    func stopLoad() {
        stopSpiner()
        enableControls()
    }
    
    func startSpiner() {
        navController?.startSpinnerForView()
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
private extension ListProductController {
    func setupCollectionView() {
//        collectionView = HomeCollectionView(gender: homeModel?.returnGender() ?? "Woman")
//        collectionView.delegate = self
//        collectionView.headerMallDelegate = self
//        collectionView.headerShopDelegate = self
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(collectionView)
//        setupConstraintsCollectionView()
    }
    
    
}

// MARK: - Layout
private extension ListProductController {
    func setupConstraintsCollectionView() {
//        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0), collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor), collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
    }
}



