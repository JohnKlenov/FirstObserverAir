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

   private lazy var collectionView: UICollectionView = {
        $0.backgroundColor = .clear
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.dataSource = self
        $0.delegate = self
        $0.register(MallCell.self, forCellWithReuseIdentifier: MallCell.reuseID)
        $0.register(ShopCellIntoMall.self, forCellWithReuseIdentifier: ShopCellIntoMall.reuseID)
        $0.register(NavigationMallCell.self, forCellWithReuseIdentifier: NavigationMallCell.reuseID)
        $0.register(MapCell.self, forCellWithReuseIdentifier: MapCell.reuseID)
        
        $0.register(HeaderTitleSection.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderTitleSection.headerIdentifier)
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: getCompositionLayout()))
    
    private var navController: NavigationController? {
            return self.navigationController as? NavigationController
        }
    
   private lazy var webAction = UIAction { [weak self] _ in
        guard let self = self else { return }
        guard let urlString = self.dataMall?.webSite else { return }
        self.presentSafariViewController(withURL: urlString)
    }
    
    private lazy var floorPlanAction = UIAction { [weak self] _ in
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
    
    deinit {
        print("deinit MallController")
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
    
    func mapSection() -> NSCollectionLayoutSection {
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
            let shopProductVC = BuilderViewController.buildListProductController(gender: gender, keyField: "shops", valueField: valueField, isArrayField: true)
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopCellIntoMall.reuseID, for: indexPath) as? ShopCellIntoMall else { return UICollectionViewCell() }
            let item = dataCollectionView[1].items[indexPath.row]
            cell.configureCell(model: item)
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCell.reuseID, for: indexPath) as? MapCell else { return UICollectionViewCell() }
            cell.delegate = self
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


// MARK: - MapCellDelegate
extension MallController: MapCellDelegate {
    func mapViewTapped() {
        let map = BuilderViewController.buildMapController(arrayPin: arrayPin)
        present(map, animated: true, completion: nil)
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
            self.arrayPin = MapHelper.convertFromPinInPlaces(pins: pins)
            self.dataMall = mallModel
            self.dataCollectionView = dataCollectionView
            self.setupView()
        })
    }
}






