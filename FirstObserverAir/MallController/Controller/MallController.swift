//
//  MapController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 18.01.24.
//

import UIKit
import MapKit
import SafariServices

class MallController: UIViewController {

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
    
//    private let mapView: MapView = {
//       let map = MapView()
//        map.translatesAutoresizingMaskIntoConstraints = false
//        map.layer.cornerRadius = 10
//        return map
//    }()
    
    private var mapView: MapView!
    
    private let mapTapGestureRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        return tapRecognizer
    }()
    
    private var collectionView:UICollectionView!
    
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
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = R.Colors.systemBackground
        
        setupScrollView()
        setupCollectionView()
        setupSubviews()
        setupMapView()
        setupConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if Int(collectionView.collectionViewLayout.collectionViewContentSize.height) == 0 {
            heightCnstrCollectionView.constant = collectionView.frame.height
        } else {
            heightCnstrCollectionView.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
        }
    }
    

    
    private func configureViews(mallModel:Int)  {
        
//        var brandSection = SectionHVC(section: "Brands", items: [])
//        brandsMall.forEach { (previewBrands) in
//            if mallModel.brands.contains(previewBrands.brand ?? "") {
//                let item = ItemCell(malls: nil, brands: previewBrands, popularProduct: nil, mallImage: nil)
//                brandSection.items.append(item)
//            }
//        }
//
//        var mallSection = SectionHVC(section: "Mall", items: [])
//        mallModel.refImage.forEach { ref in
//            let item = ItemCell(malls: nil, brands: nil, popularProduct: nil, mallImage: ref)
//            mallSection.items.append(item)
//        }
//
//        self.title = mallModel.name
//
//        if let plan = mallModel.floorPlan {
//            floorPlanMall = plan
//        } else {
//            floorPlanButton.isHidden = true
//        }
//
//        if let web = mallModel.webSite {
//            webSite = web
//        } else {
//            websiteMallButton.isHidden = true
//        }
//
//        if brandSection.items.count == mallModel.brands.count && mallSection.items.count == mallModel.refImage.count {
//            section = [mallSection, brandSection]
//        }
    }
    
    private func setupSubviews() {
        containerView.addSubview(collectionView)
        containerView.addSubview(compositeNavigationStck)
        containerView.addSubview(mapView)
    }
}

// MARK: - Setting Views
private extension MallController {
    func setupView() {
    }
}

// MARK: - Setting
private extension MallController {
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
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
        heightCnstrCollectionView = collectionView.heightAnchor.constraint(equalToConstant: 300)
        heightCnstrCollectionView.isActive = true
    }
    
    func setupBtn() {
        webPageForMallBtn = createButton(withTitle: R.Strings.OtherControllers.Mall.webPageForMallBtn, textColor: R.Colors.label, fontSize: 15, target: self, action: #selector(webPageForMallPressed(_:)), image: UIImage.SymbolConfiguration(scale: .large))
        floorPlanBtn = createButton(withTitle: R.Strings.OtherControllers.Mall.floorPlanBtn, textColor: R.Colors.label, fontSize: 15, target: self, action: #selector(floorPlanBtnPressed(_:)), image: UIImage.SymbolConfiguration(scale: .large))
        
//        if dataSource.originalContent == nil {
//            webPageForItemtBtn.isHidden = true
//        }
//
//        guard let model = dataSource.model, !model.isEmpty else {
//            addItemToCartBtn.isHidden = true
//            return
//        }
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
    
    func setupCompositeStck() {
        
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
        
        let btnStack = createStackViewWithBtns(firstButton: webPageForMallBtn, secondButton: floorPlanBtn)

        let subviews = [titleBtnStack, btnStack, titleMapView]
        subviews.forEach { compositeNavigationStck.addArrangedSubview($0) }
    }
    
    func setupMapView() {
        
        mapView = MapView(places: [Places]())
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
}

// MARK: - Selectors
private extension MallController {
    @objc func webPageForMallPressed(_ sender: UIButton) {
    }
    
    @objc func floorPlanBtnPressed(_ sender: UIButton) {
    }
    
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
        
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let fullScreenMap = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
//            fullScreenMap.arrayPin = currentPin
//            fullScreenMap.modalPresentationStyle = .fullScreen
//            present(fullScreenMap, animated: true, completion: nil)
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
            print("DidTap Default Section")
        default:
            print("DidTap Default Section")
        }
    }
}

// MARK: - SafariViewController -
extension UIViewController {
    func showWebView(_ urlString: String) {
       
        guard let url = URL(string: urlString) else { return }
        
        let vc = SFSafariViewController(url: url)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}


// MARK: - MapViewManagerDelegate
extension MallController: MapViewManagerDelegate {
    func selectAnnotationView(isSelect: Bool) {
        isMapSelected = isSelect
    }
}


    

// MARK: - Trash

//    let floorPlanButton: UIButton = {
//
//        var configuration = UIButton.Configuration.gray()
//
//        var container = AttributeContainer()
//        container.font = UIFont.boldSystemFont(ofSize: 15)
//        container.foregroundColor = R.Colors.label
//
//        configuration.attributedTitle = AttributedString(R.Strings.OtherControllers.Mall.floorPlanButton, attributes: container)
//        configuration.titleAlignment = .center
//        configuration.buttonSize = .large
//        configuration.baseBackgroundColor = R.Colors.systemPurple
//        var grayButton = UIButton(configuration: configuration)
//        grayButton.translatesAutoresizingMaskIntoConstraints = false
//
//        grayButton.addTarget(self, action: #selector(floorPlanButtonPressed(_:)), for: .touchUpInside)
//
//        return grayButton
//    }()
    
//    let webPageForMallBtn: UIButton = {
//
//        var configuration = UIButton.Configuration.gray()
//
//        var container = AttributeContainer()
//        container.font = UIFont.boldSystemFont(ofSize: 15)
//        container.foregroundColor = R.Colors.label
//
//        configuration.attributedTitle = AttributedString(R.Strings.OtherControllers.Mall.websiteMallButton, attributes: container)
//        configuration.titleAlignment = .center
//        configuration.buttonSize = .large
//        configuration.baseBackgroundColor = R.Colors.systemPurple
//        var grayButton = UIButton(configuration: configuration)
//        grayButton.translatesAutoresizingMaskIntoConstraints = false
//
//        grayButton.addTarget(self, action: #selector(websiteMallButtonPressed(_:)), for: .touchUpInside)
//        return grayButton
//    }()


//    @objc func floorPlanButtonPressed(_ sender: UIButton) {
//        self.showWebView(floorPlanMall)
//    }
    
//    @objc func websiteMallButtonPressed(_ sender: UIButton) {
//        let productVC = NewProductViewController()
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let productVC = storyboard.instantiateViewController(withIdentifier: "NewProductViewController") as! NewProductViewController
//        productVC.modalPresentationStyle = .fullScreen
//        present(productVC, animated: true, completion: nil)
//        self.showWebView(webSite)
//    }
