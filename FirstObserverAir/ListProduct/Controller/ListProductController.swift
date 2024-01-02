//
//  ListProductController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 27.12.23.
//


import UIKit

final class ListProductController: UIViewController {
    
    private var listProductModel: ListProductModelInput?
    private var dataSource: [ProductItem] = [] {
        didSet {
            collectionView?.updateData(data: dataSource)
        }
    }
    
    private var navController: NavigationController? {
            return self.navigationController as? NavigationController
        }
    private var collectionView:ListProductCollectionView!
    init(modelInput: ListProductModelInput, title:String) {
        self.listProductModel = modelInput
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchProduct()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
/// Если isMovingFromParent равно true, это означает, что контроллер представления собирается быть удален из своего родительского контроллера
        if self.isMovingFromParent {
            let isAnimating = navController?.isAnimatingSpiner()
            if let isAnimating = isAnimating, isAnimating {
                stopLoad()
            }
        }
    }
    
    deinit {
        print("deinit ListProductController")
    }
}

// MARK: - Setting DataSource
private extension ListProductController {
    func fetchProduct() {
        startLoad()
        listProductModel?.fetchProduct { [weak self] products, error in
            /// если ListProductController освобождается (например, если пользователь нажимает кнопку “назад”), self внутри обратного вызова становится nil
            guard let self = self else { return }
            self.stopLoad()
            guard let products = products, error == nil else {
                self.showErrorAlert(message: error?.localizedDescription ?? "Something went wrong!", state: .followingDataUpdate) {
                    self.fetchProduct()
                } cancelActionHandler: {
                    self.navigationController?.popViewController(animated: true)
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
        view.backgroundColor = R.Colors.systemBackground
        setupCollectionView()
        setupConstraintsCollectionView()
    }
}

// MARK: - Setting
private extension ListProductController {
    func startLoad() {
        startSpiner()
    }
    
    func stopLoad() {
        stopSpiner()
    }
    
    func startSpiner() {
        navController?.startSpinnerForView()
    }
    
    func stopSpiner() {
        navController?.stopSpinner()
    }
}

// MARK: - Setting CollectionView
private extension ListProductController {
    func setupCollectionView() {
        collectionView = ListProductCollectionView()
        collectionView.delegateListProduct = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        setupConstraintsCollectionView()
    }
}


// MARK: ListProductCollectionDelegate
extension ListProductController: ListProductCollectionDelegate {
    func didSelectCell(_ index: Int) {
        print("didSelectCell - \(index)")
    }
}

// MARK: - Layout
private extension ListProductController {
    func setupConstraintsCollectionView() {
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0), collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor), collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
    }
}


