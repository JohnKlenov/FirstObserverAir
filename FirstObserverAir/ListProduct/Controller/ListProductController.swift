//
//  ListProductController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 27.12.23.
//


import UIKit

final class ListProductController: UIViewController {
    
    private var listProductModel: ListProductModelInput?
    
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
        print("viewWillDisappear")
/// Если isMovingFromParent равно true, это означает, что контроллер представления собирается быть удален из своего родительского контроллера
        if self.isMovingFromParent {
            // Кнопка "назад" была нажата
            print("Кнопка назад была нажата")
            let isAnimating = navController?.isAnimatingSpiner()
            print("isAnimating - \(String(describing: isAnimating))")
            if let isAnimating = isAnimating, isAnimating {
                print("spiner animating")
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
            self.collectionView.updateData(data: products)
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        setupConstraintsCollectionView()
    }
}

// MARK: - Layout
private extension ListProductController {
    func setupConstraintsCollectionView() {
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0), collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor), collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
    }
}



//protocol ListProductControllerDelegate: AnyObject {
//    func updateData(data: [ProductItem]?)
//}
//final class ListProductController: UIViewController {
//
//    private var path:String
//    private var keyField:String
//    private var valueField:String
//    private var isArrayField:Bool
//
//    /// Когда ListProductService освобождается, все его обратные вызовы, которые еще не были выполнены, отменяются.
//    private var listProductModel: ListProductService?
//
//    var products: [ProductItem] = [] {
//        didSet {
////            collectionView?.updateData(data: products)
//            collectionView?.reloadData()
//        }
//    }
//
////    private var navController: NavigationController? {
////            return self.navigationController as? NavigationController
////        }
//    private var collectionView:UICollectionView?
//    init(path:String, keyField:String, valueField:String, isArrayField:Bool, title:String) {
////        self.listProductModel = modelInput
//        self.path = path
//        self.keyField = keyField
//        self.valueField = valueField
//        self.isArrayField = isArrayField
//        super.init(nibName: nil, bundle: nil)
//
//        self.title = title
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        listProductModel = ListProductService()
//        listProductModel?.delegate = self
//        setupView()
//        listProductModel?.fetchProduct()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        print("viewWillDisappear")
///// Если isMovingFromParent равно true, это означает, что контроллер представления собирается быть удален из своего родительского контроллера
//        if self.isMovingFromParent {
//            // Кнопка "назад" была нажата
//            print("Кнопка назад была нажата")
////            let isAnimating = navController?.isAnimatingSpiner()
////            print("isAnimating - \(String(describing: isAnimating))")
////            if let isAnimating = isAnimating, isAnimating {
////                print("spiner animating")
////                stopLoad()
////            }
//        }
//    }
//
//    deinit {
//        print("collectionView live - \(String(describing: collectionView))")
//        print("deinit ListProductController")
////        collectionView?.startTimer()
////        collectionView = nil
//        print("collectionView dead - \(String(describing: collectionView))")
//    }
//
////    func
//}
//
//// MARK: - Setting DataSource
//
//extension ListProductController: ListProductControllerDelegate {
//    func updateData(data: [ProductItem]?) {
//        if let data = data {
//            products = data
//        }
//
//    }
//
//
//}
//private extension ListProductController {
////    func fetchProduct() {
////        startLoad()
////
////        listProductModel?.fetchProduct { [weak self] (products, error) in
////            print("listProductModel?.fetchProduct")
////            /// если ListProductController освобождается (например, если пользователь нажимает кнопку “назад”), self внутри обратного вызова становится nil
////            guard let self = self else {
////                print("guard let self = self")
////                return
////            }
//////            self.stopLoad()
////            guard let products = products, error == nil else {
////                self.showErrorAlert(message: error?.localizedDescription ?? "Something went wrong!", state: .followingDataUpdate) {
////                    self.fetchProduct()
////                } cancelActionHandler: {
////                    self.navigationController?.popViewController(animated: true)
////                }
////                return
////            }
////
////            self.products = products
////            //            self.collectionView.updateData(data: products)
////        }
////    }
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
////        navController?.startSpinnerForView()
//    }
//
//    func stopSpiner() {
////        navController?.stopSpinner()
//    }
//}
//
//// MARK: - Setting CollectionView
//private extension ListProductController {
//    func setupCollectionView() {
////        collectionView = ListProductCollectionView()
//        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
//        collectionView?.delegate = self
//        collectionView?.dataSource = self
//        collectionView?.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(collectionView ?? UICollectionView())
//        setupConstraintsCollectionView()
//        collectionView?.register(ProductCell2.self, forCellWithReuseIdentifier: ProductCell2.reuseID)
//    }
//}
//
//// MARK: - Layout
//private extension ListProductController {
//    func setupConstraintsCollectionView() {
//        guard let collectionView = collectionView else { return }
//        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0), collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor), collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
//    }
//}
//
//
//
//// MARK: Test Implemintation Collection View
//
//extension ListProductController {
//
//    func createLayout() -> UICollectionViewLayout {
//
//        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//
//            return self.productSection()
//        }
//    return layout
//    }
//
//    func productSection() -> NSCollectionLayoutSection {
//
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(10), trailing: nil, bottom: nil)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
//        group.interItemSpacing = .fixed(10)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
//        return section
//    }
//
//}
//
//extension ListProductController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return products.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell2.reuseID, for: indexPath) as? ProductCell2 else {
//            print("Returned message for analytic FB Crashlytics error ListProductCollectionView")
//            return UICollectionViewCell()
//        }
//        let product = products[indexPath.item]
//        cell.configureCell(model: product)
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////                let product = product[indexPath.item]
////                delegate?.didSelectProduct(product: product)
//    }
//
//}

