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
            print("didSet dataSource")
            
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if Int(filterCollectionView.collectionViewLayout.collectionViewContentSize.height) == 0 {
            heightCnstrCollectionView.constant = filterCollectionView.frame.height
        } else {
            heightCnstrCollectionView.constant = filterCollectionView.collectionViewLayout.collectionViewContentSize.height
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureFilterCollectionView()
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
            
            var sortData = products
            sortData.sort { (product1, product2) -> Bool in
                guard let price1 = product1.priorityIndex, let price2 = product2.priorityIndex else {
                    return false // Обработайте случаи, когда price равно nil, если это необходимо
                }
                return price1 > price2
            }
            self.dataSource = sortData
            self.filteredDataSource = sortData
        }
    }
}

// MARK: - Setting Views
private extension ListProductController {
    
    func setupView() {
        view.backgroundColor = R.Colors.systemBackground
        setupCollectionView()
        setupFilterAndSort()
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
    
    func setupFilterAndSort() {
        if title == "All shose" {
            configureNavigationItem()
            setupAlertSorted()
        }
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
    
    func configureFilterCollectionView() {
        
        if  let isFixedPriceProducts = isFixedPriceProducts, let lowerValue = lowerValue, let upperValue = upperValue, isFixedPriceProducts {
            let rangePriceString = "from " + "\(Int(lowerValue))" + " to " + "\(Int(upperValue))" + " р."
            let indexPath = IndexPath(item: 333, section: 333)
            selectedFilterByIndex?[indexPath] = rangePriceString
        }
        
        if let selectedItem = selectedFilterByIndex {
            
            let cell = selectedItem.map{$0.value}
            print("cell - \(cell)")
            fieldsForFilters = cell
            filterCollectionView.reloadData()
            let layout = filterCollectionView.collectionViewLayout as? UserProfileTagsFlowLayout
            layout?.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//            view.setNeedsLayout()
//            view.layoutIfNeeded()
            heightCnstrCollectionView.constant = 1
        } else {
            fieldsForFilters = []
            filterCollectionView.reloadData()
            let layout = filterCollectionView.collectionViewLayout as? UserProfileTagsFlowLayout
            layout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            heightCnstrCollectionView.constant = 0
        }
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


// MARK: - Setup Alert Sorted
extension ListProductController {
    
    func setupAlertSorted() {

        alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        alert?.overrideUserInterfaceStyle = .dark
        
        
        let recommendation = UIAlertAction(title: "Recommendation", style: .default) { action in
            self.navigationItem.rightBarButtonItems?[0].tintColor = action.isEnabled ? UIColor.systemCyan : UIColor.systemPink
            self.changedAlertAction = .Recommendation
            self.sortRecommendation()
        }
        
        let priceDown = UIAlertAction(title: "PriceDown", style: .default) { action in
            self.navigationItem.rightBarButtonItems?[0].tintColor = action.isEnabled ? UIColor.systemPink : UIColor.systemCyan
            self.changedAlertAction = .PriceDown
            self.sortPriceDown()
        }

        let priceUp = UIAlertAction(title: "PriceUp", style: .default) { action in
            self.navigationItem.rightBarButtonItems?[0].tintColor = action.isEnabled ? UIColor.systemPink : UIColor.systemCyan
            self.changedAlertAction = .PriceUp
            self.sortPriceUp()
        }
        
        let alphabetically = UIAlertAction(title: "Alphabetically", style: .default) { action in
            self.navigationItem.rightBarButtonItems?[0].tintColor = action.isEnabled ? UIColor.systemPink : UIColor.systemCyan
            self.changedAlertAction = .Alphabetically
            self.sortAlphabetically()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            
        }

        let titleAlertController = NSAttributedString(string: "Sort by", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)])
        alert?.setValue(titleAlertController, forKey: "attributedTitle")

        
        alert?.addAction(recommendation)
        alert?.addAction(priceDown)
        alert?.addAction(priceUp)
        alert?.addAction(alphabetically)
        alert?.addAction(cancel)
    }
}


// MARK:  - UICollectionViewDelegate, UICollectionViewDataSource
extension ListProductController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fieldsForFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as? FilterCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.label.text = fieldsForFilters[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var labelSize = CGSize()
        var label :UILabel? = UILabel()
        label?.font = UIFont.systemFont(ofSize: 17)
        label?.textAlignment = .center
        label?.textColor = UIColor.label
        label?.text = fieldsForFilters[indexPath.item]
        
        labelSize = label?.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
        labelSize = CGSize(width: labelSize.width + labelSize.height + 20, height: labelSize.height + 10)
        label = nil
        return labelSize
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


// MARK: - Filter method
extension ListProductController {
    /// можно вынести в Helper дублируется в FilterController
    /// тут мы подаем значения по которому будем фильтровать массив и возвращаем отфильтрованный.
    func filterProductsUniversal(products: [ProductItem], color: [String]? = nil, brand: [String]? = nil, material: [String]? = nil, season: [String]? = nil, minPrice: Int? = nil, maxPrice: Int? = nil) -> [ProductItem] {
        let filteredProducts = products.filter { product in
            var isMatched = true

            if let color = color {
                isMatched = isMatched && color.contains(product.color ?? "")
            }

            if let brand = brand {
                isMatched = isMatched && brand.contains(product.brand ?? "")
            }

            if let material = material {
                isMatched = isMatched && material.contains(product.material ?? "")
            }

            if let season = season {
                isMatched = isMatched && season.contains(product.season ?? "")
            }

            if let minPrice = minPrice {
                isMatched = isMatched && (product.price ?? -1 >= minPrice)
            }

            if let maxPrice = maxPrice {
                isMatched = isMatched && (product.price ?? 1000 <= maxPrice)
            }

            return isMatched
        }

        return filteredProducts
    }
}


// MARK: - Calculate Range Price
extension ListProductController {
    /// высчитываем диапозон цен для массива продуктов
    /// видимо когда обратно на FilterController пойдем передадим диапозон цен для текущих продуктов с которыми будем работать
    private func calculateRangePrice(products: [ProductItem]) {
        
        var minPrice = Int.max
        var maxPrice = Int.min
        
        var counter = 0
        for product in products {
            counter+=1

            if let price = product.price {

                if price < minPrice {
                    minPrice = price
                }
                if price > maxPrice {
                    maxPrice = price
                }
            }
        }
        
        if counter == products.count {
            lowerValue = Double(minPrice)
            upperValue = Double(maxPrice)
        }
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

// MARK: - FilterCellDelegate
extension ListProductController: FilterCellDelegate {
    func didDeleteCellFilter(_ filterCell: FilterCell) {
        
        if let indexPath = filterCollectionView.indexPath(for: filterCell) {
            
            fieldsForFilters.remove(at: indexPath.item)
            filterCollectionView.deleteItems(at: [indexPath])
            
            view.setNeedsLayout()
            view.layoutIfNeeded()
            
            if let index = selectedFilterByIndex?.firstIndex(where: { $0.value == filterCell.label.text}) {
                if let key = selectedFilterByIndex?.first(where: { $0.value == filterCell.label.text })?.key {
                    if key == IndexPath(item: 333, section: 333) {
                        isFixedPriceProducts = false
                    }
                } else {
                    print("Returne message for analitic FB Crashlystics")
                }
                
                selectedFilterByIndex?.remove(at: index)
            }
            /// если нет критерия фильтрации
            if let selectedItem = selectedFilterByIndex, selectedItem.isEmpty {
                self.selectedFilterByIndex = nil
                self.isActiveScreenFilter = false
                // на всяк про всяк очистим проперти
                isFixedPriceProducts = nil
                minimumValue = nil
                maximumValue = nil
                lowerValue = nil
                upperValue = nil
                countFilterProduct = nil
                
                /// так как нет критерия фильтрации делаем collectionView = .zero
                let layout = filterCollectionView.collectionViewLayout as? UserProfileTagsFlowLayout
                layout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                heightCnstrCollectionView.constant = 0
                /// возвращаем все исходные товары на ListProductController
                dataSource = filteredDataSource
                applyCurrentSorting()
                navigationItem.rightBarButtonItems?[1].tintColor = UIColor.systemCyan
                
            } else if let selectedItem = selectedFilterByIndex {
                
                /// можно вынести в Helper дублируется
                /// тут мы из selectedItem по indexPath.section собираем все tagy для фильтрации продуктов
                /// то есть ищем все критерии фильтрации что мы выбрали для всех категориий - Color, Brand, Material ..
                /// затем подаем их на filterProductsUniversal и получаем массив отфильтрованных продуктов.
                let filteredColor = Array((selectedItem.filter { $0.key.section == 0 }).values)
                let color = filteredColor.isEmpty ? nil : filteredColor
                
                let filteredBrand = Array((selectedItem.filter { $0.key.section == 1 }).values)
                let brand = filteredBrand.isEmpty ? nil : filteredBrand
                
                let filteredMaterial = Array((selectedItem.filter { $0.key.section == 2 }).values)
                let material = filteredMaterial.isEmpty ? nil : filteredMaterial
                
                let filteredSeason = Array((selectedItem.filter { $0.key.section == 3 }).values)
                let season = filteredSeason.isEmpty ? nil : filteredSeason
                
                if let isFixedPriceProducts = isFixedPriceProducts, let lowerValue = lowerValue, let upperValue = upperValue, isFixedPriceProducts {
                    dataSource = filterProductsUniversal(products: filteredDataSource, color: color, brand: brand, material: material, season: season, minPrice: Int(lowerValue), maxPrice: Int(upperValue))
                    countFilterProduct = dataSource.count
                    applyCurrentSorting()
                } else {
                    dataSource = filterProductsUniversal(products: filteredDataSource, color: color, brand: brand, material: material, season: season)
                    countFilterProduct = dataSource.count
                    applyCurrentSorting()
                    if countFilterProduct == 0 {
                        lowerValue = 0
                        upperValue = 0
                    } else {
                        /// видимо когда обратно на FilterController пойдем передадим диапозон цен для текущих продуктов с которыми будем работать
                        calculateRangePrice(products: dataSource)
                    }
                }
            }
        } else {
            print("Returne message for analitic FB Crashlystics")
        }
    }
}

// MARK: - CustomRangeViewDelegate
extension ListProductController:CustomRangeViewDelegate {
    func didChangedFilterProducts(filterProducts: [ProductItem], isActiveScreenFilter: Bool?, isFixedPriceProducts: Bool?, minimumValue: Double?, maximumValue: Double?, lowerValue: Double?, upperValue: Double?, countFilterProduct: Int?, selectedItem: [IndexPath:String]?) {
        
        dataSource = filterProducts
        /// или стоит работать с applyCurrentSorting() в методах иначе - сортировать а затем отсортированный отдавать dataSource = filterProducts
        /// что бы не вызывать дважды didSet и дважды не делать reloadData.
        /// а в Action Alert оставить его.
        applyCurrentSorting()
        
        if filteredDataSource.count == filterProducts.count {
            navigationItem.rightBarButtonItems?[1].tintColor = UIColor.systemCyan
        } else {
            navigationItem.rightBarButtonItems?[1].tintColor = UIColor.systemPink
        }
        
        // MARK: set property for filter or reset filter -
        
        self.isActiveScreenFilter = isActiveScreenFilter ?? false
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.lowerValue = lowerValue
        self.upperValue = upperValue
        self.countFilterProduct = countFilterProduct
        self.selectedFilterByIndex = selectedItem
        self.isFixedPriceProducts = isFixedPriceProducts
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
