//
//  MapController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 18.01.24.
//

import UIKit
import MapKit


final class MallController: UIViewController {


    private var mallModel: MallModelInput?
    private var dataMall: Mall?
    private var arrayPin:[Places] = []
    private var dataCollectionView:[SectionModel] = []
    private var gender:String

    lazy var collectionView: UICollectionView = {
        $0.backgroundColor = .clear
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.dataSource = self
        $0.delegate = self
        $0.register(MallCell.self, forCellWithReuseIdentifier: MallCell.reuseID)
        $0.register(BrandCellMallVC.self, forCellWithReuseIdentifier: BrandCellMallVC.reuseID)
        $0.register(NavigationMallCell.self, forCellWithReuseIdentifier: NavigationMallCell.reuseID)
        $0.register(MapCell.self, forCellWithReuseIdentifier: MapCell.reuseID)
        
        $0.register(HeaderTitleSection.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderTitleSection.headerIdentifier)
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: getCompositionLayout()))
    
    private var navController: NavigationController? {
            return self.navigationController as? NavigationController
        }
    
    lazy var webAction = UIAction { [weak self] _ in
        guard let self = self else { return }
        guard let urlString = self.dataMall?.webSite else { return }
        self.presentSafariViewController(withURL: urlString)
    }
    
    lazy var floorPlanAction = UIAction { [weak self] _ in
        guard let self = self else { return }
        guard let urlString = self.dataMall?.floorPlan else { return }
        self.presentSafariViewController(withURL: urlString)
    }

    
    init(modelInput: MallModelInput, title:String, gender:String) {
        self.mallModel = modelInput
        self.gender = gender
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.Colors.systemBackground
        fetchProduct()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setting Views
private extension MallController {
    func setupView() {
        //        navigationItem.largeTitleDisplayMode = .never
        view.addSubview(collectionView)
        setupConstraints()
    }
}

// MARK: - Setting
private extension MallController {
    
    func getCompositionLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout{ [weak self] section, _ in
            
            switch section {
            case 0:
                return self?.mallSections()
            case 1:
                return self?.buttonSection()
            case 2:
                return self?.shopSection()
            case 3:
                return self?.mapSection()
            default:
                return self?.defaultSection()
            }
        }
    }
    
    func mallSections() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.97), heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 5, trailing: 0)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
    
    func shopSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20) )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(10), trailing: nil, bottom: nil)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
 
        let sizeHeader = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sizeHeader, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    private func mapSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10)
        let sizeHeader = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sizeHeader, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]

        return section
    }

    func buttonSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        let sizeHeader = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sizeHeader, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    func defaultSection() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitem: item, count: 0)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    ///  Duplicate the code
    ///  можно перенести в Application Model как static method in da class
    func getMapPin(pins:[Pin]) {
        pins.forEach { pin in
            if let latitude = pin.latitude, let longitude = pin.longitude {
                let pinMap = Places(title: pin.name, locationName: pin.address, discipline: pin.typeMall, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), imageName: pin.refImage)
                self.arrayPin.append(pinMap)
            }
        }
    }

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

// MARK: - Layout
private extension MallController {
    func setupConstraints() {
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0), collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor), collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
    }
}


// MARK: - UICollectionViewDelegate
extension MallController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            let valueField = dataCollectionView[1].items[indexPath.row].shop?.name ?? ""
            let shopProductVC = BuilderViewController.buildListProductController(gender: gender, shopName: valueField)
            navigationController?.pushViewController(shopProductVC, animated: true)
        default:
            break
        }
    }
}


// MARK: - UICollectionViewDataSource
extension MallController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return dataCollectionView[section].items.count
        case 2:
            return dataCollectionView[1].items.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MallCell.reuseID, for: indexPath) as? MallCell else { return UICollectionViewCell() }
            let item = dataCollectionView[indexPath.section].items[indexPath.row]
            cell.configureCell(model: item, isHiddenTitle: true)
            return cell
        case 1:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NavigationMallCell.reuseID, for: indexPath) as? NavigationMallCell else { return UICollectionViewCell() }
            cell.configureCell(webAction: dataMall?.webSite != nil ? webAction : nil,
                               floorPlanAction: dataMall?.floorPlan != nil ? floorPlanAction : nil)
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandCellMallVC.reuseID, for: indexPath) as? BrandCellMallVC else { return UICollectionViewCell() }
            let item = dataCollectionView[1].items[indexPath.row]
            cell.configureCell(model: item)
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCell.reuseID, for: indexPath) as? MapCell else { return UICollectionViewCell() }
            cell.configureCell(with: arrayPin)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderTitleSection.headerIdentifier, for: indexPath) as? HeaderTitleSection else {
            return UICollectionReusableView()
        }

        let title: String
        switch indexPath.section {
        case 1:
            title = R.Strings.OtherControllers.Mall.titleBtnStack
        case 2:
            title = R.Strings.OtherControllers.Mall.shopsForMall
        case 3:
            title = R.Strings.OtherControllers.Mall.titleMapView
        default:
            return UICollectionReusableView()
        }

        headerView.configureCell(title: title)
        return headerView
    }
}

// MARK: - Setting DataSource
private extension MallController {
    func fetchProduct() {
        startLoad()
        mallModel?.fetchMall(completion: { [weak self] (mallModel, dataCollectionView, pins, error) in
            guard let self = self else { return }
            self.stopLoad()
            guard let mallModel = mallModel, error == nil, let pins = pins, let dataCollectionView = dataCollectionView else {
                self.showErrorAlert(message: error?.localizedDescription ?? "Something went wrong!", state: .followingDataUpdate) {
                    self.fetchProduct()
                } cancelActionHandler: {
                    self.navigationController?.popViewController(animated: true)
                }
                return
            }
            self.getMapPin(pins: pins)
            self.dataMall = mallModel
            self.dataCollectionView = dataCollectionView
            self.setupView()
        })
    }
}






//final class MallController: UIViewController {
//
//    var heightCnstrCollectionView: NSLayoutConstraint!
//
//    private let scrollView: UIScrollView = {
//        let scroll = UIScrollView()
//        scroll.translatesAutoresizingMaskIntoConstraints = false
//        return scroll
//    }()
//
//    private let containerView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .clear
//        return view
//    }()
//
//    private var mapView: MapView!
//
//    private let mapTapGestureRecognizer: UITapGestureRecognizer = {
//        let tapRecognizer = UITapGestureRecognizer()
//        tapRecognizer.numberOfTapsRequired = 1
//        return tapRecognizer
//    }()
//
//    private var collectionView:MallCollectionView!
//
//    private var isMapSelected = false
//
//    private var floorPlanBtn: UIButton!
//    private var webPageForMallBtn: UIButton!
//
//    private let compositeNavigationStck: UIStackView = {
//        let stack = UIStackView()
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.axis = .vertical
//        stack.distribution = .fill
//        stack.spacing = 20
//        return stack
//    }()
//
//    private var mallModel: MallModelInput?
//    private var dataMall: Mall?
//    private var arrayPin:[Places] = []
//    private var dataCollectionView:[SectionModel] = []
//
//    private var navController: NavigationController? {
//            return self.navigationController as? NavigationController
//        }
//
//    init(modelInput: MallModelInput, title:String) {
//        self.mallModel = modelInput
//        super.init(nibName: nil, bundle: nil)
//        self.title = title
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = R.Colors.systemBackground
//        fetchProduct()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//    }
//
//    /// Метод viewDidLayoutSubviews() вызывается после того, как система завершает автоматическую настройку размеров и позиций подвидов для UIViewController.
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        /// collectionView.collectionViewLayout.collectionViewContentSize.height - не сразу высчитывается на это нужно время
//        guard let collectionView = collectionView else { return }
//        print("viewDidLayoutSubviews() - \(collectionView.collectionViewLayout.collectionViewContentSize.height)")
//        if Int(collectionView.collectionViewLayout.collectionViewContentSize.height) == 0 {
//            heightCnstrCollectionView.constant = 200
//        } else {
//            heightCnstrCollectionView.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
//        }
//
//        /// layoutIfNeeded в UIKit немедленно применяет любые отложенные обновления макета. Если вы вызываете layoutIfNeeded, система проверяет, есть ли какие-либо отложенные изменения в макете, и если они есть, система немедленно обновляет макет.
//        /// Отложенные изменения в макете обычно происходят, когда вы вносите изменения в данные, которые используются для создания макета вашего UICollectionView(Добавляете, удаляете или перемещаете ячейки, Изменяете размер или положение ячеек, Изменяете макет UICollectionView)
//        ///  layoutIfNeeded может потенциально привести к дополнительным вычислениям макета. Это может повлиять на производительность.
//        /// Однако важно отметить, что layoutIfNeeded будет выполнять работу только в том случае, если есть отложенные изменения макета. Если нет отложенных изменений, layoutIfNeeded не будет делать ничего, и его влияние на производительность будет минимальным.
//    }
//}
//
//// MARK: - Setting Views
//private extension MallController {
//    func setupView() {
//        //        navigationItem.largeTitleDisplayMode = .never
//        setupScrollView()
//        setupCollectionView()
//        setupMapView()
//        setupBtn()
//        setupSubviews()
//        setupConstraints()
//    }
//}
//
//// MARK: - Setting
//private extension MallController {
//
//    func setupScrollView() {
//        view.addSubview(scrollView)
//        scrollView.addSubview(containerView)
//
//        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//
//        containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//        containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
//        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
//    }
//
//    func setupCollectionView() {
//        collectionView = MallCollectionView()
//        collectionView.delegate = self
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.reloadData(data: dataCollectionView)
//        heightCnstrCollectionView = collectionView.heightAnchor.constraint(equalToConstant: 10)
//        heightCnstrCollectionView.isActive = true
//    }
//
//    func createButton(withTitle title: String, textColor: UIColor, fontSize: CGFloat, target: Any?, action: Selector, image: UIImage.SymbolConfiguration?) -> UIButton {
//        var configuration = UIButton.Configuration.gray()
//        configuration.titleAlignment = .center
//        configuration.buttonSize = .large
//        configuration.baseBackgroundColor = R.Colors.systemPurple
//        configuration.imagePlacement = .trailing
//        configuration.imagePadding = 8.0
//        configuration.preferredSymbolConfigurationForImage = image
//        var container = AttributeContainer()
//        container.font = UIFont.boldSystemFont(ofSize: fontSize)
//        container.foregroundColor = textColor
//        let attributedTitle = AttributedString(title, attributes: container)
//
//        configuration.attributedTitle = attributedTitle
//
//        let button = UIButton(configuration: configuration)
//        button.tintColor = R.Colors.label
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(target, action: action, for: .touchUpInside)
//
//        return button
//    }
//
//    func createStackViewWithBtns(buttons: [UIButton]) -> UIStackView {
//        let stackViewForButton: UIStackView = {
//            let stack = UIStackView(arrangedSubviews: buttons)
//            stack.translatesAutoresizingMaskIntoConstraints = false
//            stack.axis = .vertical
//            stack.distribution = .fill
//            stack.spacing = 5
//            return stack
//        }()
//        return stackViewForButton
//    }
//    func createStackViewWithBtns(firstButton: UIButton, secondButton: UIButton) -> UIStackView {
//        let stackViewForButton: UIStackView = {
//            let stack = UIStackView(arrangedSubviews: [firstButton, secondButton])
//            stack.translatesAutoresizingMaskIntoConstraints = false
//            stack.axis = .vertical
//            stack.distribution = .fill
//            stack.spacing = 5
//            return stack
//        }()
//        return stackViewForButton
//    }
//
//    func setupBtn() {
//
//        let titleBtnStack: UILabel = {
//            let label = UILabel()
//            label.translatesAutoresizingMaskIntoConstraints = false
//            label.text = R.Strings.OtherControllers.Mall.titleBtnStack
//            label.numberOfLines = 0
//            label.textAlignment = .left
//            label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//            label.textColor = R.Colors.label
//            label.heightAnchor.constraint(equalToConstant: 30).isActive = true
//            return label
//        }()
//
//        let titleMapView: UILabel = {
//            let label = UILabel()
//            label.translatesAutoresizingMaskIntoConstraints = false
//            label.text = R.Strings.OtherControllers.Mall.titleMapView
//            label.numberOfLines = 0
//            label.textAlignment = .left
//            label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//            label.textColor = R.Colors.label
//            return label
//        }()
//
//        var buttons = [UIButton]()
//
//        if dataMall?.webSite != nil {
//            webPageForMallBtn = createButton(withTitle: R.Strings.OtherControllers.Mall.webPageForMallBtn, textColor: R.Colors.label, fontSize: 15, target: self, action: #selector(webPageForMallPressed(_:)), image: UIImage.SymbolConfiguration(scale: .large))
//            buttons.append(webPageForMallBtn)
//        }
//
//        if dataMall?.floorPlan != nil {
//            floorPlanBtn = createButton(withTitle: R.Strings.OtherControllers.Mall.floorPlanBtn, textColor: R.Colors.label, fontSize: 15, target: self, action: #selector(floorPlanBtnPressed(_:)), image: UIImage.SymbolConfiguration(scale: .large))
//
//            buttons.append(floorPlanBtn)
//        }
//        let btnStack = createStackViewWithBtns(buttons: buttons)
//        let subviews = [titleBtnStack, btnStack, titleMapView]
//        subviews.forEach { compositeNavigationStck.addArrangedSubview($0) }
//    }
//
//    func setupMapView() {
//
//        mapView = MapView(places:arrayPin)
//        mapView.translatesAutoresizingMaskIntoConstraints = false
//        mapView.layer.cornerRadius = 10
//        mapView.isZoomEnabled = false
//        mapView.isScrollEnabled = false
//        mapView.isPitchEnabled = false
//        mapView.isRotateEnabled = false
//        mapView.delegateMap = self
//        mapTapGestureRecognizer.addTarget(self, action: #selector(didTapRecognizer(_:)))
//        mapView.addGestureRecognizer(mapTapGestureRecognizer)
//    }
//
//    func setupSubviews() {
//        containerView.addSubview(collectionView)
//        containerView.addSubview(compositeNavigationStck)
//        containerView.addSubview(mapView)
//    }
//
//    ///  Duplicate the code
//    ///  можно перенести в Application Model как static method in da class
//    func getMapPin(pins:[Pin]) {
//        pins.forEach { pin in
//            if let latitude = pin.latitude, let longitude = pin.longitude {
//                let pinMap = Places(title: pin.name, locationName: pin.address, discipline: pin.typeMall, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), imageName: pin.refImage)
//                self.arrayPin.append(pinMap)
//            }
//        }
//    }
//
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
//// MARK: - Selectors
//private extension MallController {
//    @objc func webPageForMallPressed(_ sender: UIButton) {
//        guard let urlString = dataMall?.webSite else { return }
//        self.presentSafariViewController(withURL: urlString)
//    }
//
//    @objc func floorPlanBtnPressed(_ sender: UIButton) {
//        guard let urlString = dataMall?.floorPlan else { return }
//        self.presentSafariViewController(withURL: urlString)
//    }
//
//    /// Duplicate the code
//    @objc func didTapRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
//
//        let point = gestureRecognizer.location(in: mapView)
//        var didTapOnAnnotationView = false
//        /// Находится ли точка нажатия внутри annotationMarker
//        for annotation in mapView.annotations {
//            guard let annotationView = mapView.view(for: annotation),
//                  let annotationMarker = annotationView as? MKMarkerAnnotationView,
//                  annotationMarker.point(inside: mapView.convert(point, to: annotationMarker), with: nil)
//                    /// Если условие guard не выполняется, цикл продолжается с следующей аннотацией.
//            else {
//                continue
//            }
//            /// Если условие guard выполняется, то есть нажатие было на представление аннотации, переменная didTapOnAnnotationView устанавливается в true и цикл прерывается.
//            didTapOnAnnotationView = true
//            break
//        }
//
//        if !didTapOnAnnotationView && isMapSelected == false {
//            let fullScreenMap = MapController(arrayPin: [Places]())
//            fullScreenMap.modalPresentationStyle = .fullScreen
//            present(fullScreenMap, animated: true, completion: nil)
//        }
//    }
//}
//
//// MARK: - Layout
//private extension MallController {
//    func setupConstraints() {
//        collectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
//        collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
//        collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
//        collectionView.bottomAnchor.constraint(equalTo: compositeNavigationStck.topAnchor, constant: -20).isActive = true
//        compositeNavigationStck.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
//        compositeNavigationStck.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
//        compositeNavigationStck.bottomAnchor.constraint(equalTo: mapView.topAnchor, constant: -20).isActive = true
//        mapView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
//        mapView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
//        mapView.heightAnchor.constraint(equalTo: mapView.widthAnchor, multiplier: 1).isActive = true
//        mapView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
//    }
//}
//
//// MARK: - UICollectionViewDelegate
//extension MallController: UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        switch indexPath.section {
//        case 0:
//            print("DidTap Mall Section")
//        case 1:
//            // при Cloud Firestore мы будем в NC переходить на VC с вертикальной прокруткой collectionView и cell как у popularProduct
////            let brandVC = UIStoryboard.vcById("BrandsViewController") as! BrandsViewController
////            let refPath = section[indexPath.section].items[indexPath.row].brands?.brand ?? ""
////            brandVC.pathRefBrandVC = refPath
////            brandVC.title = refPath
////            brandVC.arrayPin = arrayPin
////            self.navigationController?.pushViewController(brandVC, animated: true)
//            print("DidTap Shop Section")
//        default:
//            print("DidTap Default Section")
//        }
//    }
//}
//
//// MARK: - Setting DataSource
//private extension MallController {
//    func fetchProduct() {
//        startLoad()
//        mallModel?.fetchMall(completion: { [weak self] (mallModel, dataCollectionView, pins, error) in
//            guard let self = self else { return }
//            self.stopLoad()
//            guard let mallModel = mallModel, error == nil, let pins = pins, let dataCollectionView = dataCollectionView else {
//                self.showErrorAlert(message: error?.localizedDescription ?? "Something went wrong!", state: .followingDataUpdate) {
//                    self.fetchProduct()
//                } cancelActionHandler: {
//                    self.navigationController?.popViewController(animated: true)
//                }
//                return
//            }
//            self.getMapPin(pins: pins)
//            self.dataMall = mallModel
//            self.dataCollectionView = dataCollectionView
//            self.setupView()
//        })
//    }
//}
//
//// MARK: - MapViewManagerDelegate
//extension MallController: MapViewManagerDelegate {
//    func selectAnnotationView(isSelect: Bool) {
//        isMapSelected = isSelect
//    }
//}
//
