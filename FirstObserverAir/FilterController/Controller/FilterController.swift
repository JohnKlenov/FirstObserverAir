//
//  FilterController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 8.02.24.
//

//
//  CustomRangeViewController.swift
//  Filters
//
//  Created by Evgenyi on 14.09.23.
//

import UIKit

enum StateFirstStart {
    case nul
    case reset
    case firstStart
}

class CustomRangeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var dataSource = [String:[String]]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var allProducts:[ProductItem] = []
    var filterProducts:[ProductItem] = [] {
        didSet {
            customTabBarView.setCounterButton(count: filterProducts.count)
            if filterProducts.isEmpty {
                isForcedPrice = true
                rangeSlider.isEnabled = false
                rangeView.updateLabels(lowerValue: 0, upperValue: 0)
            } else {
                calculatePriceForFilterProducts(products: filterProducts)
            }
        }
    }
    
    var fixedPriceFilterProducts:[ProductItem] = [] {
        didSet {
            customTabBarView.setCounterButton(count: fixedPriceFilterProducts.count)
        }
    }
    var stateReturnFilterProduct: StateFirstStart = .nul
    
    var selectedItem: [IndexPath:String] = [:]
    var isForcedPrice: Bool = false
    var isFixedPriceProducts:Bool = false
    
//    var dataManager = FactoryProducts.shared
    
    // MARK: property for fixed filter screen -
    
    var isActiveScreenFilter:Bool = false
    var minimumValue: Double?
    var maximumValue: Double?
    var lowerValue: Double?
    var upperValue: Double?
    
    var countFilterProduct:Int?
    
    private let collectionView: UICollectionView = {
        
        let layout = UserProfileTagsFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let closeButton: UIButton = {
        var configButton = UIButton.Configuration.plain()
        configButton.title = "Close"
        configButton.baseForegroundColor = UIColor.systemCyan
        configButton.titleAlignment = .leading
        configButton.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incomig in

            var outgoing = incomig
            outgoing.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            return outgoing
        }
        var button = UIButton(configuration: configButton)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let resetButton: UIButton = {
        var configButton = UIButton.Configuration.plain()
        configButton.title = "Reset"
        configButton.baseForegroundColor = UIColor.systemCyan
        configButton.titleAlignment = .trailing
        configButton.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incomig in

            var outgoing = incomig
            outgoing.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            return outgoing
        }
        var button = UIButton(configuration: configButton)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let customTabBarView: CustomTabBarView = {
        let view = CustomTabBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let rangeView = RangeView()
    let rangeSlider = RangeSlider(frame: .zero)

    weak var delegate:CustomRangeViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        collectionView.dataSource = self
        collectionView.delegate = self
        customTabBarView.delegate = self
        collectionView.backgroundColor = .clear

        collectionView.register(MyCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(HeaderFilterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderFilterCollectionReusableView.headerIdentifier)
        
        view.addSubview(rangeView)
        view.addSubview(rangeSlider)
        view.addSubview(collectionView)
        view.addSubview(customTabBarView)
        configureNavigationBar(largeTitleColor: UIColor.label, backgoundColor: UIColor.secondarySystemBackground, tintColor: UIColor.label, title: "Filters", preferredLargeTitle: false)
        configureNavigationItem()
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(rangeSlider:)), for: .valueChanged)
        rangeSlider.addTarget(self, action: #selector(rangeSliderTouchUpInside(rangeSlider:)), for: .touchUpInside)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: rangeSlider.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: customTabBarView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            customTabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if !isActiveScreenFilter {
            calculateDataSource(products: allProducts)
            customTabBarView.setCounterButton(count: allProducts.count)
            stateReturnFilterProduct = .firstStart
        } else {
            customTabBarView.setCounterButton(count: countFilterProduct ?? 0)
            stateReturnFilterProduct = .firstStart
            calculateDataSourceForScreenFilter(products: allProducts)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rangeView.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 90)
        rangeSlider.frame = CGRect(x: 10, y: rangeView.frame.maxY, width: UIScreen.main.bounds.width - 20, height: 30)
        
    }
    
    @objc func rangeSliderValueChanged(rangeSlider: RangeSlider) {
        if !isForcedPrice {
            rangeView.updateLabels(lowerValue: rangeSlider.lowerValue, upperValue: rangeSlider.upperValue)
        }
    }
    
    @objc func rangeSliderTouchUpInside(rangeSlider: RangeSlider) {
        
        /// дубликат
        let filteredColor = Array((selectedItem.filter { $0.key.section == 0 }).values)
        let color = filteredColor.isEmpty ? nil : filteredColor
        
        let filteredBrand = Array((selectedItem.filter { $0.key.section == 1 }).values)
        let brand = filteredBrand.isEmpty ? nil : filteredBrand
        
        let filteredMaterial = Array((selectedItem.filter { $0.key.section == 2 }).values)
        let material = filteredMaterial.isEmpty ? nil : filteredMaterial
        
        let filteredSeason = Array((selectedItem.filter { $0.key.section == 3 }).values)
        let season = filteredSeason.isEmpty ? nil : filteredSeason
        
        stateReturnFilterProduct = .nul
        isFixedPriceProducts = true
        lowerValue = rangeSlider.lowerValue
        upperValue = rangeSlider.upperValue
        fixedPriceFilterProducts = filterProductsUniversal(products: allProducts, color: color, brand: brand, material: material, season: season, minPrice: Int(rangeSlider.lowerValue), maxPrice: Int(rangeSlider.upperValue))
    }
    
    
    @objc func didTapCloseButton() {
        
        if stateReturnFilterProduct == .reset {
            delegate?.didChangedFilterProducts(filterProducts: allProducts, isActiveScreenFilter: false, isFixedPriceProducts: false, minimumValue: nil, maximumValue: nil, lowerValue: nil, upperValue: nil, countFilterProduct: nil, selectedItem: nil)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapResetButton() {
        
        // we must inform the close button that the settings have been reset
        stateReturnFilterProduct = .reset
        isActiveScreenFilter = false
        countFilterProduct = nil
        minimumValue = nil
        maximumValue = nil
        lowerValue = nil
        upperValue = nil
        rangeSlider.isEnabled = true
        isForcedPrice = false
        isFixedPriceProducts = false
        selectedItem = [:]
        
        customTabBarView.setCounterButton(count: allProducts.count)
        calculatePriceForFilterProducts(products: allProducts)
        collectionView.reloadData()
    }

    private func configureNavigationItem() {
        
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(didTapResetButton), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: resetButton)
    }
    
    private func configureRangeView(minimumValue:Double, maximumValue:Double) {
        rangeSlider.minimumValue = minimumValue
        rangeSlider.maximumValue = maximumValue
        rangeSlider.lowerValue = minimumValue
        rangeSlider.upperValue = maximumValue
    }
    
    private func configureRangeViewForScreenFilter(minimumValue:Double, maximumValue:Double, lowerValue:Double, upperValue:Double ) {
        rangeSlider.minimumValue = minimumValue
        rangeSlider.maximumValue = maximumValue
        rangeSlider.lowerValue = lowerValue
        rangeSlider.upperValue = upperValue
    }
    
    /// для каждой категории фильтрации создаем уникальные значения которые есть в массиве продуктов
    private func calculateDataSource(products: [ProductItem]) {

        var minPrice = Int.max
        var maxPrice = Int.min
        var dataSource = [String: [String]]()
        var counter = 0
        for product in products {
            counter+=1
            if let color = product.color {
                dataSource["color", default: []].append(color)
            }
            if let brand = product.brand {
                dataSource["brand", default: []].append(brand)
            }
            if let material = product.material {
                dataSource["material", default: []].append(material)
            }
            if let season = product.season {
                dataSource["season", default: []].append(season)
            }
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
            for key in dataSource.keys {
                /// создаем Array(values) с уникальными значениями через Set
                let values = Set(dataSource[key]!)
                dataSource[key] = Array(values)
                let sortValue = dataSource[key]?.sorted()
                dataSource[key] = sortValue
            }
            minimumValue = Double(minPrice)
            maximumValue = Double(maxPrice)
            configureRangeView(minimumValue: Double(minPrice), maximumValue: Double(maxPrice))
            self.dataSource = dataSource
        }
    }
    
    private func calculateDataSourceForScreenFilter(products: [ProductItem]) {

        var dataSource = [String: [String]]()
        var counter = 0
        for product in products {
            counter+=1
            if let color = product.color {
                dataSource["color", default: []].append(color)
            }
            if let brand = product.brand {
                dataSource["brand", default: []].append(brand)
            }
            if let material = product.material {
                dataSource["material", default: []].append(material)
            }
            if let season = product.season {
                dataSource["season", default: []].append(season)
            }
        }
        if counter == products.count {
            for key in dataSource.keys {
                let values = Set(dataSource[key]!)
                dataSource[key] = Array(values)
                let sortValue = dataSource[key]?.sorted()
                dataSource[key] = sortValue
            }
           /// если мы фильтровали по price первая ветка иначе вторая
            /// если во второй minimumValue, maximumValue, lowerValue, upperValue nil то выходим
            ///  если не nil то две ветки, последняя про то что они равны
            if isFixedPriceProducts {
                if let minimumValue = minimumValue, let maximumValue = maximumValue, let lowerValue = lowerValue, let upperValue = upperValue  {
                    configureRangeViewForScreenFilter(minimumValue: minimumValue, maximumValue: maximumValue, lowerValue: lowerValue, upperValue: upperValue)
                    }
            } else {
                if let minimumValue = minimumValue, let maximumValue = maximumValue, let lowerValue = lowerValue, let upperValue = upperValue  {
                    if lowerValue != upperValue {
                        configureRangeViewForScreenFilter(minimumValue: lowerValue, maximumValue: upperValue, lowerValue: lowerValue, upperValue: upperValue)
                    } else {
                        configureRangeViewForScreenFilter(minimumValue: minimumValue, maximumValue: maximumValue, lowerValue: minimumValue, upperValue: maximumValue)
                        isForcedPrice = true
                        rangeSlider.isEnabled = false
                        rangeView.updateLabels(lowerValue: lowerValue, upperValue: upperValue)
                    }
                }
            }
            self.dataSource = dataSource
        }
    }
    
    private func calculatePriceForFilterProducts(products: [ProductItem]) {
        
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
            if minPrice != maxPrice {
                configureRangeView(minimumValue: Double(minPrice), maximumValue: Double(maxPrice))
            } else {
                isForcedPrice = true
                rangeSlider.isEnabled = false
                rangeView.updateLabels(lowerValue: Double(minPrice), upperValue: Double(maxPrice))
            }
            
        }
    }
    
    /// можно вынести в Helper дублируется в ListProductController
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
    
    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return dataSource["color"]?.count ?? 0
        case 1:
            return dataSource["brand"]?.count ?? 0
        case 2:
            return dataSource["material"]?.count ?? 0
        case 3:
            return dataSource["season"]?.count ?? 0
        default:
            print("Returned message for analytic FB Crashlytics error")
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MyCell else {
            return UICollectionViewCell()
        }
        
        if let _ = selectedItem[indexPath] {
            cell.contentView.backgroundColor = UIColor.systemCyan
               } else {
                   cell.contentView.backgroundColor = UIColor.secondarySystemBackground
               }
        
        switch indexPath.section {
        case 0:
            let colors = dataSource["color"]
            cell.label.text = colors?[indexPath.row]
        case 1:
            let brands = dataSource["brand"]
            cell.label.text = brands?[indexPath.row]
        case 2:
            let material = dataSource["material"]
            cell.label.text = material?[indexPath.row]
        case 3:
            let season = dataSource["season"]
            cell.label.text = season?[indexPath.row]
        default:
            print("Returned message for analytic FB Crashlytics error")
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        stateReturnFilterProduct = .nul
        isForcedPrice = false
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? MyCell else {
            return
        }
        
        let item = cell.label.text ?? ""
        
        /// если такой tag был нажат мы его удаляем в selectedItem иначу добавляем
        if let _ = selectedItem[indexPath] {
            selectedItem[indexPath] = nil
        } else {
            selectedItem[indexPath] = item
        }
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
        
        if !isFixedPriceProducts {
            rangeSlider.isEnabled = true
            filterProducts = filterProductsUniversal(products: allProducts, color: color, brand: brand, material: material, season: season)
        } else {
            fixedPriceFilterProducts = filterProductsUniversal(products: allProducts, color: color, brand: brand, material: material, season: season, minPrice: Int(rangeSlider.lowerValue), maxPrice: Int(rangeSlider.upperValue))
        }

        // уходим от анимированного изменения цвета
        UIView.performWithoutAnimation {
               collectionView.reloadItems(at: [indexPath])
           }
    }
    
    

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        var labelSize = CGSize()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MyCell
        
        switch indexPath.section {
        case 0:
            let colors = dataSource["color"]
            cell?.label.text = colors?[indexPath.row]
            //             Определяем размеры метки с помощью метода sizeThatFits()
            labelSize = cell?.label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
            labelSize = CGSize(width: labelSize.width + 20, height: labelSize.height + 20)
        case 1:
            let brands = dataSource["brand"]
            cell?.label.text = brands?[indexPath.row]
            labelSize = cell?.label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
            labelSize = CGSize(width: labelSize.width + 20, height: labelSize.height + 20)
        case 2:
            let material = dataSource["material"]
            cell?.label.text = material?[indexPath.row]
            labelSize = cell?.label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
            labelSize = CGSize(width: labelSize.width + 20, height: labelSize.height + 20)
        case 3:
            let season = dataSource["season"]
            cell?.label.text = season?[indexPath.row]
            labelSize = cell?.label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
            labelSize = CGSize(width: labelSize.width + 20, height: labelSize.height + 20)
        default:
            print("Returned message for analytic FB Crashlytics error")
            labelSize = .zero
        }
        return labelSize
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderFilterCollectionReusableView.headerIdentifier, for: indexPath) as! HeaderFilterCollectionReusableView

            // Customize your header view here based on the section index
            switch indexPath.section {
            case 0:
                headerView.configureCell(title: "Color")
            case 1:
                headerView.configureCell(title: "Brand")
            case 2:
                headerView.configureCell(title: "Material")
            case 3:
                headerView.configureCell(title: "Season")
            default:
                break
            }

            return headerView
        }
        fatalError("Unexpected element kind")
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let headerView = HeaderFilterCollectionReusableView()
        headerView.configureCell(title: "Test")
        let width = collectionView.bounds.width
        let height = headerView.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)).height
        
        return CGSize(width: width, height: height)
    }
    
    deinit {
        print("deinit CustomRangeViewController")
    }
}

extension CustomRangeViewController: CustomTabBarViewDelegate {
    
    func customTabBarViewDidTapButton(_ tabBarView: CustomTabBarView) {
        
        switch stateReturnFilterProduct {
            
        case .nul:
            returnFilterProducts()
        case .reset:
            delegate?.didChangedFilterProducts(filterProducts: allProducts, isActiveScreenFilter: false, isFixedPriceProducts: false, minimumValue: nil, maximumValue: nil, lowerValue: nil, upperValue: nil, countFilterProduct: nil, selectedItem: nil)
        case .firstStart:
            break
        }

        self.dismiss(animated: true, completion: nil)
    }
    
    func returnFilterProducts() {
        if !isFixedPriceProducts {
            if filterProducts.count != allProducts.count {
                delegate?.didChangedFilterProducts(filterProducts: filterProducts, isActiveScreenFilter: true, isFixedPriceProducts: false, minimumValue: minimumValue, maximumValue: maximumValue, lowerValue: rangeView.lowerValue, upperValue: rangeView.upperValue, countFilterProduct: filterProducts.count, selectedItem: selectedItem)
            } else {
                delegate?.didChangedFilterProducts(filterProducts: filterProducts, isActiveScreenFilter: false, isFixedPriceProducts: false, minimumValue: nil, maximumValue: nil, lowerValue: nil, upperValue: nil, countFilterProduct: nil, selectedItem: nil)
            }
        } else {
            if fixedPriceFilterProducts.count != allProducts.count {
                delegate?.didChangedFilterProducts(filterProducts: fixedPriceFilterProducts, isActiveScreenFilter: true, isFixedPriceProducts: true, minimumValue: minimumValue, maximumValue: maximumValue, lowerValue: lowerValue, upperValue: upperValue, countFilterProduct: fixedPriceFilterProducts.count, selectedItem: selectedItem)
            } else {
                delegate?.didChangedFilterProducts(filterProducts: fixedPriceFilterProducts, isActiveScreenFilter: false, isFixedPriceProducts: true, minimumValue: nil, maximumValue: nil, lowerValue: nil, upperValue: nil, countFilterProduct: nil, selectedItem: nil)
            }
        }
    }
}

extension UIViewController {

    /// configure navigationBar and combines status bar with navigationBar
    func configureNavigationBar(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
    if #available(iOS 13.0, *) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
        navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
        navBarAppearance.backgroundColor = backgoundColor
        navBarAppearance.shadowColor = .clear

        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

        navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = tintColor
        navigationItem.title = title

    } else {
        // Fallback on earlier versions
        navigationController?.navigationBar.barTintColor = backgoundColor
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.layer.shadowColor = nil
        navigationItem.title = title
    }
}}
