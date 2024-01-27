//
//  MapController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 18.01.24.
//

import UIKit
import MapKit

final class MallController: UIViewController {

    var heightCnstrCollectionView: NSLayoutConstraint!
    
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
    
    private var mapView: MapView!
    
    private let mapTapGestureRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        return tapRecognizer
    }()
    
    private var collectionView:MallCollectionView!
    
    private var isMapSelected = false
    
    private var floorPlanBtn: UIButton!
    private var webPageForMallBtn: UIButton!
    
    private let compositeNavigationStck: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 20
        return stack
    }()
    
    private var mallModel: MallModelInput?
    private var dataMall: Mall?
    private var arrayPin:[Places] = []
    private var dataCollectionView:[SectionModel] = []
    
    private var navController: NavigationController? {
            return self.navigationController as? NavigationController
        }
    
    init(modelInput: MallModelInput, title:String) {
        self.mallModel = modelInput
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.Colors.systemBackground
        fetchProduct()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    /// Метод viewDidLayoutSubviews() вызывается после того, как система завершает автоматическую настройку размеров и позиций подвидов для UIViewController.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let collectionView = collectionView else { return }
        print("viewDidLayoutSubviews() - \(collectionView.collectionViewLayout.collectionViewContentSize.height)")
        if Int(collectionView.collectionViewLayout.collectionViewContentSize.height) == 0 {
            heightCnstrCollectionView.constant = 200
        } else {
            heightCnstrCollectionView.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
        }
    
        /// layoutIfNeeded в UIKit немедленно применяет любые отложенные обновления макета. Если вы вызываете layoutIfNeeded, система проверяет, есть ли какие-либо отложенные изменения в макете, и если они есть, система немедленно обновляет макет.
        /// Отложенные изменения в макете обычно происходят, когда вы вносите изменения в данные, которые используются для создания макета вашего UICollectionView(Добавляете, удаляете или перемещаете ячейки, Изменяете размер или положение ячеек, Изменяете макет UICollectionView)
        ///  layoutIfNeeded может потенциально привести к дополнительным вычислениям макета. Это может повлиять на производительность.
        /// Однако важно отметить, что layoutIfNeeded будет выполнять работу только в том случае, если есть отложенные изменения макета. Если нет отложенных изменений, layoutIfNeeded не будет делать ничего, и его влияние на производительность будет минимальным.
    }
}

// MARK: - Setting Views
private extension MallController {
    func setupView() {
        //        navigationItem.largeTitleDisplayMode = .never
        setupScrollView()
        setupCollectionView()
        setupMapView()
        setupBtn()
        setupSubviews()
        setupConstraints()
    }
}

// MARK: - Setting
private extension MallController {
    
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
        collectionView = MallCollectionView()
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
       
        
print("setupCollectionView - \(collectionView.collectionViewLayout.collectionViewContentSize.height)")
        collectionView.reloadData(data: dataCollectionView)
        heightCnstrCollectionView = collectionView.heightAnchor.constraint(equalToConstant: 10)
        heightCnstrCollectionView.isActive = true
        
//        collectionView.sizeToFit()
//        collectionView.setNeedsLayout()
        
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
    
    func createStackViewWithBtns(buttons: [UIButton]) -> UIStackView {
        let stackViewForButton: UIStackView = {
            let stack = UIStackView(arrangedSubviews: buttons)
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .vertical
            stack.distribution = .fill
            stack.spacing = 5
            return stack
        }()
        return stackViewForButton
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
    
    func setupBtn() {
        
        let titleBtnStack: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = R.Strings.OtherControllers.Mall.titleBtnStack
            label.numberOfLines = 0
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            label.textColor = R.Colors.label
            label.heightAnchor.constraint(equalToConstant: 30).isActive = true
            return label
        }()
        
        let titleMapView: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = R.Strings.OtherControllers.Mall.titleMapView
            label.numberOfLines = 0
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            label.textColor = R.Colors.label
            return label
        }()
        
        var buttons = [UIButton]()
        
        if dataMall?.webSite != nil {
            webPageForMallBtn = createButton(withTitle: R.Strings.OtherControllers.Mall.webPageForMallBtn, textColor: R.Colors.label, fontSize: 15, target: self, action: #selector(webPageForMallPressed(_:)), image: UIImage.SymbolConfiguration(scale: .large))
            buttons.append(webPageForMallBtn)
        }
        
        if dataMall?.floorPlan != nil {
            floorPlanBtn = createButton(withTitle: R.Strings.OtherControllers.Mall.floorPlanBtn, textColor: R.Colors.label, fontSize: 15, target: self, action: #selector(floorPlanBtnPressed(_:)), image: UIImage.SymbolConfiguration(scale: .large))
            
            buttons.append(floorPlanBtn)
        }
        let btnStack = createStackViewWithBtns(buttons: buttons)
        let subviews = [titleBtnStack, btnStack, titleMapView]
        subviews.forEach { compositeNavigationStck.addArrangedSubview($0) }
    }
    
    func setupMapView() {
        
        mapView = MapView(places:arrayPin)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.cornerRadius = 10
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.delegateMap = self
        mapTapGestureRecognizer.addTarget(self, action: #selector(didTapRecognizer(_:)))
        mapView.addGestureRecognizer(mapTapGestureRecognizer)
    }
    
    func setupSubviews() {
        containerView.addSubview(collectionView)
        containerView.addSubview(compositeNavigationStck)
        containerView.addSubview(mapView)
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

// MARK: - Selectors
private extension MallController {
    @objc func webPageForMallPressed(_ sender: UIButton) {
        guard let urlString = dataMall?.webSite else { return }
        self.presentSafariViewController(withURL: urlString)
    }
    
    @objc func floorPlanBtnPressed(_ sender: UIButton) {
        guard let urlString = dataMall?.floorPlan else { return }
        self.presentSafariViewController(withURL: urlString)
    }
    
    /// Duplicate the code
    @objc func didTapRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        
        let point = gestureRecognizer.location(in: mapView)
        var didTapOnAnnotationView = false
        /// Находится ли точка нажатия внутри annotationMarker
        for annotation in mapView.annotations {
            guard let annotationView = mapView.view(for: annotation),
                  let annotationMarker = annotationView as? MKMarkerAnnotationView,
                  annotationMarker.point(inside: mapView.convert(point, to: annotationMarker), with: nil)
                    /// Если условие guard не выполняется, цикл продолжается с следующей аннотацией.
            else {
                continue
            }
            /// Если условие guard выполняется, то есть нажатие было на представление аннотации, переменная didTapOnAnnotationView устанавливается в true и цикл прерывается.
            didTapOnAnnotationView = true
            break
        }
        
        if !didTapOnAnnotationView && isMapSelected == false {
            let fullScreenMap = MapController(arrayPin: [Places]())
            fullScreenMap.modalPresentationStyle = .fullScreen
            present(fullScreenMap, animated: true, completion: nil)
        }
    }
}

// MARK: - Layout
private extension MallController {
    func setupConstraints() {
        collectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: compositeNavigationStck.topAnchor, constant: -20).isActive = true
        compositeNavigationStck.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        compositeNavigationStck.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        compositeNavigationStck.bottomAnchor.constraint(equalTo: mapView.topAnchor, constant: -20).isActive = true
        mapView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        mapView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        mapView.heightAnchor.constraint(equalTo: mapView.widthAnchor, multiplier: 1).isActive = true
        mapView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
    }
}

// MARK: - UICollectionViewDelegate
extension MallController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            print("DidTap Mall Section")
        case 1:
            // при Cloud Firestore мы будем в NC переходить на VC с вертикальной прокруткой collectionView и cell как у popularProduct
//            let brandVC = UIStoryboard.vcById("BrandsViewController") as! BrandsViewController
//            let refPath = section[indexPath.section].items[indexPath.row].brands?.brand ?? ""
//            brandVC.pathRefBrandVC = refPath
//            brandVC.title = refPath
//            brandVC.arrayPin = arrayPin
//            self.navigationController?.pushViewController(brandVC, animated: true)
            print("DidTap Shop Section")
        default:
            print("DidTap Default Section")
        }
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

// MARK: - MapViewManagerDelegate
extension MallController: MapViewManagerDelegate {
    func selectAnnotationView(isSelect: Bool) {
        isMapSelected = isSelect
    }
}

