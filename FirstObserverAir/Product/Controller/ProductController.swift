//
//  ProductController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 2.01.24.
//

import MapKit
import UIKit

// Протокол для обработки полученных данных
protocol ProductModelOutput:AnyObject {
    func updateData(shops: [Shop], pins: [Pin], isAddedToCard:Bool)
}

final class ProductController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private var imageCollectionView : UICollectionView!
    
    private let pagesView: NumberPagesView = {
        let view = NumberPagesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        control.currentPageIndicatorTintColor = R.Colors.label
        control.pageIndicatorTintColor = R.Colors.systemGray
        control.addTarget(self, action: #selector(didTapPageControl(_:)), for: .valueChanged)
        return control
    }()
    
    private var addItemToCartBtn: UIButton!
    private var webPageForItemtBtn: UIButton!
    
    private let compositeStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 20
        return stack
    }()
    
    private let titleMallTableViewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = R.Strings.OtherControllers.Product.titleTableViewLabel
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = R.Colors.label
        return label
    }()
    
    private let mallTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = R.Colors.systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let titleMapLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = R.Strings.OtherControllers.Product.titleMapLabel
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = R.Colors.label
        return label
    }()
    
    private let mapView: MinskMapView = {
       let map = MinskMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.layer.cornerRadius = 10
        return map
    }()
    
    private let mapTapGestureRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        return tapRecognizer
    }()
    
    private var productModel: ProductModelInput?
    
    // MARK: - Constraint property
    private var heightCnstrTableView: NSLayoutConstraint!
    
    // MARK: - model property
    private var dataSource:ProductItem
    private var arrayPin:[Places] = []
    private var shops: [Shop] = []
    private var isAddedToCard = false {
        didSet {
            if let _ = addItemToCartBtn {
                addItemToCartBtn.setNeedsUpdateConfiguration()
            }
        }
    }
    
    private var isActivityIndicatorBtn = false {
        didSet {
            if let _ = addItemToCartBtn {
                addItemToCartBtn.setNeedsUpdateConfiguration()
            }
        }
    }
    
    private let encoder = JSONEncoder()
    private var isMapSelected = false
    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait // Разрешить все ориентации для этого контроллера
//    }
    
    init(product: ProductItem) {
        self.dataSource = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = R.Colors.systemBackground
        tabBarController?.tabBar.isHidden = true
//        navigationItem.largeTitleDisplayMode = .never
        productModel = ProductFirebaseService(output: self)
        productModel?.fetchPinAndShopForProduct(shops: dataSource.shops, model: dataSource.model, gender: dataSource.gender)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let heightTV:CGFloat = CGFloat(arrayPin.count)*50
        heightCnstrTableView.constant = heightTV
    }
    
    deinit {
        print("Deinit NewProductViewController")
    }
}

// MARK: - Setting Views
private extension ProductController {
    
    func setupView() {
        setupBtn()
        configureToCardButton()
        setupScrollView()
        setupCollectionView()
        setupStackView()
        setupTableView()
        setupMapView()
        addSubviews()
        setupConstraints()
    }
    
    func setupDataSource(shopsProduct: [Shop], pinsProduct: [Pin], isAddedToCardProduct: Bool) {
        getMapPin(pins: pinsProduct)
        shops = shopsProduct
        isAddedToCard = isAddedToCardProduct
        pageControl.numberOfPages = dataSource.refImage?.count ?? 1
        pagesView.configureView(currentPage: 1, count: dataSource.refImage?.count ?? 0)
        mapView.arrayPin = arrayPin
    }
}

// MARK: - Setting
private extension ProductController {
    
    func setupBtn() {
        addItemToCartBtn = createButton(withTitle: R.Strings.OtherControllers.Product.addToCardButton, textColor: R.Colors.label, fontSize: 15, target: self, action: #selector(addItemToCartPressed(_:)), image: UIImage.SymbolConfiguration(scale: .large))
        webPageForItemtBtn = createButton(withTitle: R.Strings.OtherControllers.Product.websiteButton, textColor: R.Colors.label, fontSize: 15, target: self, action: #selector(webPageForItemPressed(_:)), image: UIImage.SymbolConfiguration(scale: .large))
        
        if dataSource.originalContent == nil {
            webPageForItemtBtn.isHidden = true
        }
        
        guard let model = dataSource.model, !model.isEmpty else {
            addItemToCartBtn.isHidden = true
            return
        }
    }
    
    func createButton(withTitle title: String, textColor: UIColor, fontSize: CGFloat, target: Any?, action: Selector, image: UIImage.SymbolConfiguration?) -> UIButton {
        var configuration = UIButton.Configuration.gray()
        configuration.titleAlignment = .center
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = R.Colors.systemPurple
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 8.0
        configuration.preferredSymbolConfigurationForImage = image
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: fontSize)
        container.foregroundColor = textColor
        let attributedTitle = AttributedString(title, attributes: container)

        configuration.attributedTitle = attributedTitle

        let button = UIButton(configuration: configuration)
        button.tintColor = R.Colors.label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(target, action: action, for: .touchUpInside)

        return button
    }
    
    func configureToCardButton() {
        addItemToCartBtn.configurationUpdateHandler = { [weak self] button in
            guard let isAddedToCard = self?.isAddedToCard, let isActivityIndicatorBtn = self?.isActivityIndicatorBtn else {return}
            var config = button.configuration
            var container = AttributeContainer()
            container.font = UIFont.boldSystemFont(ofSize: 15)
            container.foregroundColor = R.Colors.label
            
            config?.attributedTitle = isAddedToCard ? AttributedString(R.Strings.OtherControllers.Product.addedToCardButton, attributes: container) : AttributedString(R.Strings.OtherControllers.Product.addToCardButton, attributes: container)
            config?.image = isAddedToCard ? UIImage(systemName: R.Strings.OtherControllers.Product.imageSystemNameCartFill)?.withTintColor(R.Colors.label, renderingMode: .alwaysOriginal) : UIImage(systemName: R.Strings.OtherControllers.Product.imageSystemNameCart)?.withTintColor(R.Colors.label, renderingMode: .alwaysOriginal)
            config?.showsActivityIndicator = isActivityIndicatorBtn
            button.isEnabled = !isAddedToCard
            button.configuration = config
        }
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .horizontal
        imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imageCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseID)

        imageCollectionView.backgroundColor = .clear
        imageCollectionView.isPagingEnabled = true
        imageCollectionView.showsVerticalScrollIndicator = false
        imageCollectionView.showsHorizontalScrollIndicator = false
    }
    
    func setupStackView() {
        /// nameStack
        let brand = dataSource.brand ?? ""
        let model = dataSource.model ?? ""
        let brandModel = "\(brand) \(model)"
        let price = dataSource.price != nil ? String(dataSource.price!) : ""
        /// descriptionStack
        let description = dataSource.description ?? ""
        let nameStack = createStackViewWithLabels(firstLabelText: brandModel, firstLabelFont: UIFont.systemFont(ofSize: 20, weight: .bold), secondLabelText: price, secondLabelFont: UIFont.systemFont(ofSize: 17, weight: .medium))
        let descriptionStack = createStackViewWithLabels(firstLabelText: R.Strings.OtherControllers.Product.descriptionTitleLabel, firstLabelFont: UIFont.systemFont(ofSize: 17, weight: .bold), secondLabelText: description, secondLabelFont: UIFont.systemFont(ofSize: 15, weight: .medium))
        let btnStack = createStackViewWithBtns(firstButton: webPageForItemtBtn, secondButton: addItemToCartBtn)

        let subviews = [nameStack, btnStack, descriptionStack]
        subviews.forEach { compositeStackView.addArrangedSubview($0) }
    }
    
    func createStackViewWithLabels(firstLabelText: String, firstLabelFont: UIFont, secondLabelText: String, secondLabelFont: UIFont) -> UIStackView {
        // Создание первой метки
        let firstLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = firstLabelText
            label.numberOfLines = 0
            label.textAlignment = .left
            label.font = firstLabelFont
            label.textColor = R.Colors.label
            return label
        }()
        
        // Создание второй метки
        let secondLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = secondLabelText
            label.numberOfLines = 0
            label.textAlignment = .left
            label.font = secondLabelFont
            label.textColor = R.Colors.label
            return label
        }()
        
        // Создание stack view
        let stackViewForLabel: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [firstLabel, secondLabel])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .vertical
            stack.distribution = .fill
            stack.spacing = 10
            return stack
        }()
        
        return stackViewForLabel
    }
    
    func createStackViewWithBtns(firstButton: UIButton, secondButton: UIButton) -> UIStackView {
        let stackViewForButton: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [firstButton, secondButton])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .vertical
            stack.distribution = .fill
            stack.spacing = 5
            return stack
        }()
        return stackViewForButton
    }
    
    func setupTableView() {
        mallTableView.delegate = self
        mallTableView.dataSource = self
        mallTableView.register(MallTableViewCell.self, forCellReuseIdentifier: MallTableViewCell.reuseID)
        heightCnstrTableView = mallTableView.heightAnchor.constraint(equalToConstant: 50)
        heightCnstrTableView.isActive = true
    }
    
    func setupMapView() {
        mapView.delegateMap = self
        mapTapGestureRecognizer.addTarget(self, action: #selector(didTapRecognizer(_:)))
        mapView.addGestureRecognizer(mapTapGestureRecognizer)
    }
    
    func addSubviews() {
        
        [imageCollectionView, pageControl, compositeStackView, titleMallTableViewLabel, mallTableView, titleMapLabel, mapView, pagesView].forEach {
            containerView.addSubview($0)
        }
    }
    
    func getMapPin(pins:[Pin]) {
        pins.forEach { pin in
            if let latitude = pin.latitude, let longitude = pin.longitude {
                let pinMap = Places(title: pin.name, locationName: pin.address, discipline: pin.typeMall, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), imageName: pin.refImage)
                self.arrayPin.append(pinMap)
            }
        }
    }
    
    func getShopForMall(indexPath:Int) -> Shop? {
        let mall = arrayPin[indexPath].title
        var selectedShop:[Shop] = []
        shops.forEach { (item) in
                        if item.mall == mall {
                            selectedShop.append(item)
                        }
                    }
        return selectedShop.first
    }
    
    func configureBadgeValue() {
        if let items = self.tabBarController?.tabBar.items {
            if let badgeValue = items[3].badgeValue {
                let currentCount = (Int(badgeValue) ?? 0) + 1
                items[3].badgeValue = "\(currentCount)"
            } else {
                items[3].badgeValue = "1"
            }
        }
    }
    
    func showAlertView(state: AlertType, frame: CGRect) {
        let alert = AddToCartAnimationView(alertType: state, frame: frame)
        view.addSubview(alert)
    }
}

// MARK: - Layout
private extension ProductController {
    func setupConstraints() {
        imageCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        imageCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        imageCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        imageCollectionView.heightAnchor.constraint(equalTo: imageCollectionView.widthAnchor, multiplier: 1).isActive = true
        imageCollectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -10).isActive = true
        
        pageControl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: compositeStackView.topAnchor, constant: -20).isActive = true
        
        compositeStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        compositeStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        compositeStackView.bottomAnchor.constraint(equalTo: titleMallTableViewLabel.topAnchor, constant: -20).isActive = true
        
        titleMallTableViewLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        titleMallTableViewLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        titleMallTableViewLabel.bottomAnchor.constraint(equalTo: mallTableView.topAnchor, constant: -10).isActive = true
        
        mallTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        mallTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        mallTableView.bottomAnchor.constraint(equalTo: titleMapLabel.topAnchor, constant: -20).isActive = true
        
        titleMapLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        titleMapLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        titleMapLabel.bottomAnchor.constraint(equalTo: mapView.topAnchor, constant: -10).isActive = true
        
        mapView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        mapView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        mapView.heightAnchor.constraint(equalTo: mapView.widthAnchor, multiplier: 1).isActive = true
        mapView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
        
        pagesView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        pagesView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
    }
}

// MARK: - Selectors
private extension ProductController {
    
    @objc func didTapRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        
        var countFalse = 0
        
        for annotation in mapView.annotations {
            
            if let annotationView = mapView.view(for: annotation), let annotationMarker = annotationView as? MKMarkerAnnotationView {
                
                let point = gestureRecognizer.location(in: mapView)
                let convertPoint = mapView.convert(point, to: annotationMarker)
                if annotationMarker.point(inside: convertPoint, with: nil) {
                } else {
                    countFalse+=1
                }
            }
        }
        if countFalse == mapView.annotations.count, isMapSelected == false {
            let fullScreenMap = MapController()
            fullScreenMap.modalPresentationStyle = .fullScreen
            fullScreenMap.arrayPin = arrayPin
            present(fullScreenMap, animated: true, completion: nil)
        }
    }
    
    @objc func addItemToCartPressed(_ sender: UIButton) {
        isActivityIndicatorBtn = true
        productModel?.addItemForCartProduct(dataSource, completion: { [weak self] error in
            guard let self = self else { return }
            self.isActivityIndicatorBtn = false
            if let _ = error {
                self.showAlertView(state: .failed, frame: self.view.frame)
            } else {
                self.showAlertView(state: .success, frame: self.view.frame)
                self.configureBadgeValue()
                self.isAddedToCard = !self.isAddedToCard
            }
        })
    }
    
    @objc func webPageForItemPressed(_ sender: UIButton) {
        guard let urlString = dataSource.originalContent else { return }
        self.presentSafariViewController(withURL: urlString)
    }
    
    @objc func didTapPageControl(_ sender: UIPageControl) {
        imageCollectionView.scrollToItem(at: IndexPath(item: sender.currentPage, section: 0), at: .centeredHorizontally, animated: true)
        pagesView.configureView(currentPage: sender.currentPage + 1, count: dataSource.refImage?.count ?? 0)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ProductController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.refImage?.count ?? 0
    }
    /// as? ImageCell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseID, for: indexPath) as? ImageCell, let refImage = dataSource.refImage?[indexPath.row] else { return UICollectionViewCell() }
//        guard let refImage = dataSource.refImage?[indexPath.row] else { return UICollectionViewCell() }
        cell.configureCell(refImage: refImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width - 10, height: collectionView.frame.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let refImages = dataSource.refImage else {return}
        let fullScreenVC = FullScreenImageController(refImages: refImages, indexPath: IndexPath(item: indexPath.row, section: 0))
        fullScreenVC.modalPresentationStyle = .fullScreen
        present(fullScreenVC, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ProductController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPin.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MallTableViewCell.reuseID, for: indexPath) as? MallTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(refImage: arrayPin[indexPath.row].imageName ?? "not ref", nameMall: arrayPin[indexPath.row].title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ShopDetailController()
        vc.modalPresentationStyle = .pageSheet
        vc.sheetPresentationController?.detents = [.medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        
        let selectedShop = getShopForMall(indexPath: indexPath.row)
        vc.configureViews(model: selectedShop)
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - MapViewManagerDelegate
extension ProductController: MapViewManagerDelegate {
    func selectAnnotationView(isSelect: Bool) {
        isMapSelected = isSelect
    }
}

// MARK: - ProductModelOutput
extension ProductController: ProductModelOutput {
    func updateData(shops: [Shop], pins: [Pin], isAddedToCard: Bool) {
//        originalContent : https://all-stars.by/store/women/shoes/krossovki/krossovki-nike-wmns-waffle-debut-dh9523-100/
        setupDataSource(shopsProduct: shops, pinsProduct: pins, isAddedToCardProduct: isAddedToCard)
        setupView()
    }
}

// MARK: - UIScrollViewDelegate
extension ProductController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == imageCollectionView {
            let currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            pageControl.currentPage = currentPage
            pagesView.configureView(currentPage: currentPage + 1, count: dataSource.refImage?.count ?? 0)
        } else {
            print("scrolling another view")
        }
    }
}











// MARK: - Trash

//    let addItemToCartBtn: UIButton = {
//
//        var configuration = UIButton.Configuration.gray()
//
//        configuration.titleAlignment = .center
//        configuration.buttonSize = .large
//        configuration.baseBackgroundColor = R.Colors.systemPurple
//        configuration.imagePlacement = .trailing
//        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .large)
//        var grayButton = UIButton(configuration: configuration)
//
//        grayButton.translatesAutoresizingMaskIntoConstraints = false
//        grayButton.addTarget(self, action: #selector(addItemToCartPressed(_:)), for: .touchUpInside)
//
//        return grayButton
//    }()
//
//    let webPageForItemtBtn: UIButton = {
//
//        var configuration = UIButton.Configuration.gray()
//
//        var container = AttributeContainer()
//        container.font = UIFont.boldSystemFont(ofSize: 15)
//        container.foregroundColor = R.Colors.label
//
//        configuration.attributedTitle = AttributedString(R.Strings.OtherControllers.Product.websiteButton, attributes: container)
//        configuration.titleAlignment = .center
//        configuration.buttonSize = .large
//        configuration.baseBackgroundColor = R.Colors.systemPurple
//
//        var grayButton = UIButton(configuration: configuration)
//        grayButton.translatesAutoresizingMaskIntoConstraints = false
//
//        grayButton.addTarget(self, action: #selector(webPageForItemPressed(_:)), for: .touchUpInside)
//
//        return grayButton
//    }()

//    let nameLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Naike Air"
//        label.textAlignment = .left
//        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
//        label.textColor = R.Colors.label
//        return label
//    }()
//
//    let priceLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
////        label.text = "450 BYN"
//        label.textAlignment = .left
//        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//        label.textColor = R.Colors.label
//
//        return label
//    }()
//
//
//    let descriptionTitleLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = R.Strings.OtherControllers.Product.descriptionTitleLabel
//        label.numberOfLines = 0
//        label.textAlignment = .left
//        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
//        label.textColor = R.Colors.label
//        return label
//    }()
//
//    let descriptionLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = ""
//        label.numberOfLines = 0
//        label.textAlignment = .left
//        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
//        label.textColor = R.Colors.label
//        return label
//    }()

//    let stackViewForButton: UIStackView = {
//        let stack = UIStackView()
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.axis = .vertical
//        stack.distribution = .fill
//        stack.spacing = 5
//        return stack
//    }()
//
//    let stackViewForLabel: UIStackView = {
//        let stack = UIStackView()
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.axis = .vertical
//        stack.distribution = .fill
//        stack.spacing = 10
//        return stack
//    }()
//
//    let stackViewForDescription: UIStackView = {
//        let stack = UIStackView()
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.axis = .vertical
//        stack.distribution = .fill
//        stack.spacing = 10
//        return stack
//    }()

//        stackViewForLabel.addArrangedSubview(nameLabel)
//        stackViewForLabel.addArrangedSubview(priceLabel)
//        stackViewForButton.addArrangedSubview(webPageForItemtBtn)
//        stackViewForButton.addArrangedSubview(addItemToCartBtn)
//        stackViewForDescription.addArrangedSubview(descriptionTitleLabel)
//        stackViewForDescription.addArrangedSubview(descriptionLabel)
//
//        compositeStackView.addArrangedSubview(stackViewForLabel)
//        compositeStackView.addArrangedSubview(stackViewForButton)
//        compositeStackView.addArrangedSubview(stackViewForDescription)

//        pageControl.numberOfPages = dataSource.refImage?.count ?? 1
//        pagesView.configureView(currentPage: 1, count: dataSource.refImage?.count ?? 0)
//        mapView.arrayPin = arrayPin
//        mapView.delegateMap = self
//        mapTapGestureRecognizer.addTarget(self, action: #selector(didTapRecognizer(_:)))
//        mapView.addGestureRecognizer(mapTapGestureRecognizer)

//    private func configureAlertView(state: AlertType) {
////        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        let containerView = UIView(frame: self.view.frame)
//        containerView.center = view.center
//        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        view.addSubview(containerView)
//
//        let successAlert = TestCustomAlertView(alertType: state)
//        containerView.addSubview(successAlert)
//        successAlert.translatesAutoresizingMaskIntoConstraints = false
//
//        let centerXConstraint = successAlert.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
//        let centerYConstraint = successAlert.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
//        let widthConstraint = successAlert.widthAnchor.constraint(equalToConstant: 200)
//        let heightConstraint = successAlert.heightAnchor.constraint(equalToConstant: 200)
//        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint, widthConstraint, heightConstraint])
//
//        successAlert.showAnimation()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
//            successAlert.hideAnimation {
//                containerView.removeFromSuperview()
//            }
//        })
//
//    }

//    private func alertViewSP(present: AlertIcon) {
//
////        AlertKitAPI.present(
////            title: "Added to Library",
////            icon: present,
////            style: .iOS17AppleMusic,
////            haptic: .success
////        )
////        let alertView = SPAlertView(title: "Product added to cart", preset: present)
////        alertView.layout.margins.top = 30
////        alertView.layout.iconSize = .init(width: view.frame.width/4, height: view.frame.width/4)
////        alertView.duration = 2
////        alertView.present()
//    }
