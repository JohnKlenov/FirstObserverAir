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
    
    // MARK: Filter property
    
    var filteredDataSource: [ProductItem] = []
    var fieldsForFilters: [String] = []
    
    var alert:UIAlertController?
    var changedAlertAction:AlertActions = .Recommendation

    /// говорит о том есть ли у нас активные fields для filters
    var isActiveScreenFilter:Bool = false
    var minimumValue: Double?
    var maximumValue: Double?
    var lowerValue: Double?
    var upperValue: Double?
    var countFilterProduct:Int?
    /// фиксирует что массив фильтруется по Price
    var isFixedPriceProducts:Bool?
    var selectedFilterByIndex: [IndexPath:String]?
    
    var heightCnstrCollectionView: NSLayoutConstraint!
    
    private let filterCollectionView: UICollectionView = {
        let layout = UserProfileTagsFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
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
        setupConstraints()
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
        
        ///
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.register(FilterCell.self, forCellWithReuseIdentifier: "filterCell")
        heightCnstrCollectionView = filterCollectionView.heightAnchor.constraint(equalToConstant: 0)
        heightCnstrCollectionView.isActive = true
        filterCollectionView.backgroundColor = .clear
        view.addSubview(filterCollectionView)
    }
}


// MARK: ListProductCollectionDelegate
extension ListProductController: ListProductCollectionDelegate {
    func didSelectCell(_ index: Int) {
        let product = dataSource[index]
        let productVC = ProductController(product: product)
        navigationController?.pushViewController(productVC, animated: true)
    }
}


// MARK: - Layout
private extension ListProductController {
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            filterCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            filterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            filterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            filterCollectionView.bottomAnchor.constraint(equalTo: collectionView.topAnchor)
        ])
        /// collectionView.topAnchor.constraint(equalTo: filterCollectionView.bottomAnchor, constant: 0) поидее можно убрать
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: filterCollectionView.bottomAnchor, constant: 0), collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor), collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
    }
}






// MARK: - Filter implemintation -

enum AlertActions:String {
    case Recommendation
    case PriceDown
    case PriceUp
    case Alphabetically
}


protocol CustomRangeViewDelegate: AnyObject {
    func didChangedFilterProducts(filterProducts:[ProductItem], isActiveScreenFilter:Bool?, isFixedPriceProducts:Bool?, minimumValue: Double?, maximumValue: Double?, lowerValue: Double?, upperValue: Double?, countFilterProduct:Int?, selectedItem: [IndexPath:String]?)
}


// MARK: Sort methods
private extension ListProductController {
    
    func sortAlphabetically() {
        dataSource.sort { (product1, product2) -> Bool in
            guard let brand1 = product1.brand, let brand2 = product2.brand else {
                return false // Обработайте случаи, когда brand равно nil, если это необходимо
            }
            return brand1.localizedCaseInsensitiveCompare(brand2) == .orderedAscending
        }
    }

    func sortPriceDown() {
        dataSource.sort { (product1, product2) -> Bool in
            guard let price1 = product1.price, let price2 = product2.price else {
                return false // Обработайте случаи, когда price равно nil, если это необходимо
            }
            return price1 > price2
        }
    }

    func sortPriceUp() {
        dataSource.sort { (product1, product2) -> Bool in
            guard let price1 = product1.price, let price2 = product2.price else {
                return false // Обработайте случаи, когда price равно nil, если это необходимо
            }
            return price1 < price2
        }
    }

    func sortRecommendation() {
        /// после сортировки срабатывает didSet?
        dataSource.sort { (product1, product2) -> Bool in
            guard let price1 = product1.priorityIndex, let price2 = product2.priorityIndex else {
                return false // Обработайте случаи, когда price равно nil, если это необходимо
            }
            return price1 > price2
        }
    }
    
    func applyCurrentSorting() {
        switch changedAlertAction {
        case .Recommendation:
            sortRecommendation()
        case .PriceDown:
            sortPriceDown()
        case .PriceUp:
            sortPriceUp()
        case .Alphabetically:
            sortAlphabetically()
        }
    }
}


// MARK:  - UICollectionViewDelegate, UICollectionViewDataSource
extension ListProductController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}


// MARK: Setting
private extension ListProductController {
    func configureNavigationItem() {
        
        // Создание кнопок
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease"), style: .plain, target: self, action: #selector(filterButtonTapped))
        filterButton.tintColor = UIColor.systemCyan
        let sortedButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(sortedButtonTapped))
        sortedButton.tintColor = UIColor.systemCyan
        navigationItem.rightBarButtonItems = [sortedButton, filterButton]
    }
}

// MARK: - Selector
private extension ListProductController {
    
    @objc func filterButtonTapped() {
        
//        let indexPath = IndexPath(item: 333, section: 333)
//        selectedFilterByIndex?[indexPath] = nil
//
//        let customVC = CustomRangeViewController()
//        customVC.allProducts = reserverDataSource
//        customVC.delegate = self
//        if isActiveScreenFilter {
//            customVC.selectedItem = selectedFilterByIndex ?? [:]
//            customVC.minimumValue = minimumValue
//            customVC.maximumValue = maximumValue
//            customVC.lowerValue = lowerValue
//            customVC.upperValue = upperValue
//            customVC.countFilterProduct = countFilterProduct
//            customVC.isActiveScreenFilter = isActiveScreenFilter
//            customVC.isFixedPriceProducts = isFixedPriceProducts ?? false
//        }
//        let navigationVC = CustomNavigationController(rootViewController: customVC)
//        navigationVC.navigationBar.backgroundColor = UIColor.secondarySystemBackground
//        navigationVC.modalPresentationStyle = .fullScreen
//        present(navigationVC, animated: true, completion: nil)
    }

    @objc func sortedButtonTapped() {
        
//        if let alert = alert {
//            alert.actions.forEach { action in
//                if action.title == changedAlertAction.rawValue {
//                    action.setValue(UIColor.systemGray3, forKey: "titleTextColor")
//                    action.isEnabled = false
//                } else {
//                    action.isEnabled = true
//                    action.setValue(UIColor.systemCyan, forKey: "titleTextColor")
//                }
//
//            }
//            present(alert, animated: true, completion: nil)
//        }
//    }
}
}


















//import UIKit
//
//final class ListProductController: UIViewController {
//
//    private var listProductModel: ListProductModelInput?
//    private var dataSource: [ProductItem] = [] {
//        didSet {
//            collectionView?.updateData(data: dataSource)
//        }
//    }
//
//
//    private var navController: NavigationController? {
//            return self.navigationController as? NavigationController
//        }
//    private var collectionView:ListProductCollectionView!
//
//    init(modelInput: ListProductModelInput, title:String) {
//        self.listProductModel = modelInput
//        super.init(nibName: nil, bundle: nil)
//        self.title = title
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupView()
//        fetchProduct()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
///// Если isMovingFromParent равно true, это означает, что контроллер представления собирается быть удален из своего родительского контроллера
//        if self.isMovingFromParent {
//            let isAnimating = navController?.isAnimatingSpiner()
//            if let isAnimating = isAnimating, isAnimating {
//                stopLoad()
//            }
//        }
//    }
//
//    deinit {
//        print("deinit ListProductController")
//    }
//}
//
//// MARK: - Setting DataSource
//private extension ListProductController {
//    func fetchProduct() {
//        startLoad()
//        listProductModel?.fetchProduct { [weak self] products, error in
//            /// если ListProductController освобождается (например, если пользователь нажимает кнопку “назад”), self внутри обратного вызова становится nil
//            guard let self = self else { return }
//            self.stopLoad()
//            guard let products = products, error == nil else {
//                self.showErrorAlert(message: error?.localizedDescription ?? "Something went wrong!", state: .followingDataUpdate) {
//                    self.fetchProduct()
//                } cancelActionHandler: {
//                    self.navigationController?.popViewController(animated: true)
//                }
//                return
//            }
//            self.dataSource = products
//        }
//    }
//}
//
//// MARK: - Setting Views
//private extension ListProductController {
//
//    func setupView() {
//        view.backgroundColor = R.Colors.systemBackground
//        setupCollectionView()
//        setupConstraintsCollectionView()
//    }
//}
//
//// MARK: - Setting
//private extension ListProductController {
//    func startLoad() {
//        startSpiner()
//    }
//
//    func stopLoad() {
//        stopSpiner()
//    }
//
//    func startSpiner() {
//        navController?.startSpinnerForView()
//    }
//
//    func stopSpiner() {
//        navController?.stopSpinner()
//    }
//}
//
//// MARK: - Setting CollectionView
//private extension ListProductController {
//    func setupCollectionView() {
//        collectionView = ListProductCollectionView()
//        collectionView.delegateListProduct = self
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(collectionView)
//        setupConstraintsCollectionView()
//    }
//}
//
//
//// MARK: ListProductCollectionDelegate
//extension ListProductController: ListProductCollectionDelegate {
//    func didSelectCell(_ index: Int) {
//        let product = dataSource[index]
//        let productVC = ProductController(product: product)
//        navigationController?.pushViewController(productVC, animated: true)
//    }
//}
//
//
//// MARK: - Layout
//private extension ListProductController {
//    func setupConstraintsCollectionView() {
//        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0), collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor), collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
//    }
//}
//
//
