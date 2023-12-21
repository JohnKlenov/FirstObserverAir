//
//  HomeController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 26.11.23.
//

import UIKit

// Протокол для обработки полученных данных
protocol HomeModelOutput:AnyObject {
    func updateData(data: [String:SectionModel]?, error: Error?)
}

final class HomeController: UIViewController {

    private var homeModel: HomeModelInput?
    
    var navController: NavigationController? {
            return self.navigationController as? NavigationController
        }
    private var collectionViewLayout:UICollectionView!
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<SectionModel, Item>?
    
    var stateDataSource: StateDataSource = .firstDataUpdate
    var dataSource:[SectionModel] = [] {
        didSet {
            reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switchGender()
        /// можно переместить его во viewDidLoad
        NotificationCenter.default.addObserver(self, selector: #selector(handleFailedFetchPersonalDataNotification(_:)), name: NSNotification.Name("FailedFetchPersonalDataNotification"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /// можно переместить его в updateData
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("FailedFetchPersonalDataNotification"), object: nil)
    }
}


// MARK: - Selectors
private extension HomeController {
    @objc func handleFailedFetchPersonalDataNotification(_ notification: NSNotification) {
        stopLoad()
        if let userInfo = notification.userInfo,
           let error = userInfo["error"] as? NSError,
           let enumValue = userInfo["enumValue"] as? ListenerErrorState {
            showErrorAlert(message: error.localizedDescription, state: self.stateDataSource) {
                self.startLoad()
                switch enumValue {
                    
                case .restartFetchCartProducts:
                    self.homeModel?.restartFetchCartProducts()
                case .restartObserveUser:
                    self.homeModel?.observeUserAndCardProducts()
                }
            }
        }
    }
}

// MARK: - Setting Views
private extension HomeController {
    
    func setupView() {
        view.backgroundColor = R.Colors.systemBackground
        homeModel = HomeFirebaseService(output: self)
        checkConnectionAndSetupModel()
        setupCollectionView()
        
//        tabBarController?.view.isUserInteractionEnabled = false
//        title = "Observer"
//        navigationController?.navigationBar.prefersLargeTitles = true
    }
}



// MARK: - Setting DataSource
private extension HomeController {
    
    func checkConnectionAndSetupModel() {
        
        if NetworkMonitor.shared.isConnected {
            navController?.hiddenPlaceholder()
            fetchDataAndUser()
        } else {
            navController?.showPlaceholder()
            showErrorAlert(message: "No internet connection!", state: stateDataSource) {
                // Повторно проверяем подключение, когда вызывается блок в showErrorAlert
                self.checkConnectionAndSetupModel()
            }
        }
    }
    
    func fetchDataAndUser() {
        startLoad()
        homeModel?.observeUserAndCardProducts()
    }
    
    func switchGender() {
        homeModel?.isSwitchGender(completion: {
            self.forceFetchGenderData()
        })
    }
    
    func forceFetchGenderData() {
        startLoad()
        homeModel?.fetchGenderData()
    }
    
    func forceFirstFetchData() {
        startLoad()
        homeModel?.firstFetchData()
    }
    
    func convertDictionaryToArray(data:[String : SectionModel]) -> [SectionModel] {
        let sortedDictionary = data.sorted { $0.key < $1.key }
        let array = Array(sortedDictionary.map({ $0.value }))
        return array
    }
}


// MARK: - Setting
private extension HomeController {
    func startLoad() {
        startSpiner()
        disableControls()
    }
    
    func stopLoad() {
        stopSpiner()
        enableControls()
    }
    
    func startSpiner() {
        navController?.startSpinnerForWindow()
    }
    
    func stopSpiner() {
        navController?.stopSpinner()
    }
    
    func disableControls() {
        // Отключите все элементы управления
        // Например, если у вас есть кнопка:
        // myButton.isEnabled = false
    }
    
    func enableControls() {
        // Включите все элементы управления
        // Например, если у вас есть кнопка:
        // myButton.isEnabled = true
    }
}

// MARK: - Setting CollectionView
private extension HomeController {
    
    func setupCollectionView() {
        createCollectionView()
        setupConstraintsCollectionView()
        createDataSource()
        collectionViewLayout.delegate = self
    }
    
    func createCollectionView() {
        
        collectionViewLayout = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(collectionViewLayout)
        collectionViewLayout.translatesAutoresizingMaskIntoConstraints = false
        collectionViewLayout.backgroundColor = .clear
        
        collectionViewLayout.register(MallCell.self, forCellWithReuseIdentifier: MallCell.reuseID)
        collectionViewLayout.register(ShopCell.self, forCellWithReuseIdentifier: ShopCell.reuseID)
        collectionViewLayout.register(PopProductCell.self, forCellWithReuseIdentifier: PopProductCell.reuseID)
        collectionViewLayout.register(HeaderMallSection.self, forSupplementaryViewOfKind: "HeaderMall", withReuseIdentifier: HeaderMallSection.headerIdentifier)
        collectionViewLayout.register(HeaderShopSection.self, forSupplementaryViewOfKind: "HeaderShop", withReuseIdentifier: HeaderShopSection.headerIdentifier)
        collectionViewLayout.register(HeaderPopProductSection.self, forSupplementaryViewOfKind: "HeaderPopProduct", withReuseIdentifier: HeaderPopProductSection.headerIdentifier)
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let section = self.dataSource[sectionIndex]
            
            switch section.section {
            case "Malls":
                return self.mallSection()
            case "Shops":
                return self.shopSection()
            case "PopularProducts":
                return self.popProductSection()
            default:
                print("default createLayout")
                return self.mallSection()
            }
        }
        layout.register(BackgroundViewCollectionReusableView.self, forDecorationViewOfKind: "background")
    return layout
    }
    
    func mallSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(0.55))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous

        let sizeHeader = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sizeHeader, elementKind: "HeaderMall", alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    func shopSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/5), heightDimension: .fractionalWidth(1/5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        
        let sizeHeader = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sizeHeader, elementKind: "HeaderShop", alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    func popProductSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(10), trailing: nil, bottom: nil)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 10, trailing: 15)
        
        let background = NSCollectionLayoutDecorationItem.background(elementKind: "background")
        background.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        section.decorationItems = [background]
        
        let sizeHeader = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sizeHeader, elementKind: "HeaderPopProduct", alignment: .top)
        header.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    func createDataSource() {

        collectionViewDataSource = UICollectionViewDiffableDataSource<SectionModel, Item>(collectionView: collectionViewLayout, cellProvider: { collectionView, indexPath, cellData in
            switch self.dataSource[indexPath.section].section {
            case "Malls":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MallCell.reuseID, for: indexPath) as? MallCell
                cell?.configureCell(model: cellData)
                return cell
            case "Shops":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopCell.reuseID, for: indexPath) as? ShopCell
                cell?.configureCell(model: cellData)
                return cell
            case "PopularProducts":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopProductCell.reuseID, for: indexPath) as? PopProductCell
                cell?.configureCell(model: cellData)
                return cell
            default:
                print("default createDataSource")
                return UICollectionViewCell()
            }
        })
        
        collectionViewDataSource?.supplementaryViewProvider = { collectionView, kind, IndexPath in
            
            if kind == "HeaderMall" {
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: HeaderMallSection.headerIdentifier, withReuseIdentifier: HeaderMallSection.headerIdentifier, for: IndexPath) as? HeaderMallSection
                cell?.delegate = self
                cell?.configureCell(title: R.Strings.TabBarController.Home.ViewsHome.headerMallView, gender: self.homeModel?.gender ?? "Woman")
//                cell?.configureCell(title: R.Strings.TabBarController.Home.ViewsHome.headerProductView)
                return cell
            } else if kind == "HeaderShop" {
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: HeaderShopSection.headerIdentifier, withReuseIdentifier: HeaderShopSection.headerIdentifier, for: IndexPath) as? HeaderShopSection
                cell?.delegate = self
                cell?.configureCell(title: R.Strings.TabBarController.Home.ViewsHome.headerShopView)
                return cell
            } else if kind == "HeaderPopProduct" {
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: HeaderPopProductSection.headerIdentifier, withReuseIdentifier: HeaderPopProductSection.headerIdentifier, for: IndexPath) as? HeaderPopProductSection
                cell?.configureCell(title: R.Strings.TabBarController.Home.ViewsHome.headerProductView)
                return cell
            } else {
                return nil
            }
        }
    }
    
    private func reloadData() {

        var snapshot = NSDiffableDataSourceSnapshot<SectionModel, Item>()
        snapshot.appendSections(dataSource)

        for section in dataSource {
            snapshot.appendItems(section.items, toSection: section)
        }
        collectionViewDataSource?.apply(snapshot)
       
    }

}

// MARK: - Layout
private extension HomeController {
    func setupConstraintsCollectionView() {
        NSLayoutConstraint.activate([collectionViewLayout.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0), collectionViewLayout.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), collectionViewLayout.trailingAnchor.constraint(equalTo: view.trailingAnchor), collectionViewLayout.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
    }
}

extension HomeController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("indexPath - \(indexPath.row)")
    }
}
// MARK: - HomeModelOutput
extension HomeController:HomeModelOutput {
    
    func updateData(data: [String:SectionModel]?, error: Error?) {
        
        stopLoad()
        
        switch self.stateDataSource {
            
        case .firstDataUpdate:
            guard let data = data, error == nil else {
                
                self.navController?.showPlaceholder()
                self.showErrorAlert(message: error?.localizedDescription ?? "Something went wrong!", state: self.stateDataSource) {
                    self.forceFirstFetchData()
                }
                return
            }
            self.navController?.hiddenPlaceholder()
            self.stateDataSource = .followingDataUpdate
            
            self.dataSource = self.convertDictionaryToArray(data: data)
            
        case .followingDataUpdate:
            guard let data = data, error == nil else {
                self.showErrorAlert(message: error?.localizedDescription ?? "Something went wrong!", state: self.stateDataSource) {
                    self.forceFetchGenderData()
                }
                return
            }
            self.dataSource = self.convertDictionaryToArray(data: data)
            self.homeModel?.updateModelGender()
        }
    }
}
    

// MARK: - HeaderMallSectionDelegate
extension HomeController:HeaderMallSectionDelegate {
    func didSelectSegmentControl(gender: String) {
        homeModel?.setGender(gender: gender)
        switchGender()
    }
}

// MARK: - HeaderShopSectionDelegate
extension HomeController:HeaderShopSectionDelegate {
    func didSelectAllShopButton() {
        print("")
    }
    
    
}


    
    
    
    
    
    
    
    
