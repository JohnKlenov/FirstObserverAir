//
//  CatalogController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 26.11.23.
//

import UIKit

// Протокол для обработки полученных данных
protocol CatalogModelOutput:AnyObject {
    func updateData(data: [PreviewSection]?, error: Error?)
}

final class CatalogController: UIViewController {

    private var catalogModel: CatalogModelInput?
    private var stateDataSource: StateDataSource = .firstDataUpdate
    private var stateCancelAlert: StateCancelShowErrorAlert = .switchGenderFailed
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height) / 4)
        layout.minimumInteritemSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MallCell.self, forCellWithReuseIdentifier: MallCell.reuseID)
        collectionView.register(HeaderCatalogSection.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCatalogSection.headerIdentifier)
        
        return collectionView
    }()
    
    var dataSource:[PreviewSection] = [] {
        didSet {
//            collectionView.reloadData(data: dataSource, gender: homeModel?.returnLocalGender() ?? "Woman")
        }
    }
    
    var navController: NavigationController? {
            return self.navigationController as? NavigationController
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let isEmpty = catalogModel?.isEmptyPathsGenderListener(), isEmpty, stateDataSource == .followingDataUpdate {
            stateCancelAlert = .forcedUpdateDataFailed
            fetchGenderData()
        } else {
            switchGender()
        }
    }
    
}

// MARK: - Setting Views
private extension CatalogController {
    
    func setupView() {
        title = "Catalog"
        view.backgroundColor = R.Colors.systemBackground
//        catalogModel = CatalogFirebaseService(output: self)
//        checkConnectionAndSetupModel()
        setupCollectionView()
        setupConstraints()
    }
}

// MARK: - Setting
private extension CatalogController {
    
    func setupCollectionView() {
        view.addSubview(collectionView)
    }
    
    func startLoad() {
        startSpiner()
        setUserInteraction(false)
    }
    
    func stopLoad() {
        stopSpiner()
        setUserInteraction(true)
    }
    
    func startSpiner() {
        navController?.startSpinnerForWindow()
    }
    
    func stopSpiner() {
        navController?.stopSpinner()
    }
}

// MARK: - Layout
private extension CatalogController {
    func setupConstraints() {
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0), collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor), collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
    }

}

// MARK: - Setting DataSource
private extension CatalogController {
    
    func checkConnectionAndSetupModel() {
        
        if NetworkMonitor.shared.isConnected {
            print("NetworkMonitor.shared.isConnected")
            navController?.hiddenPlaceholder()
            fetchGenderData()
        } else {
            navController?.showPlaceholder()
            showErrorAlert(message: "No internet connection!", state: .followingDataUpdate) {
                // Повторно проверяем подключение, когда вызывается блок в showErrorAlert
                self.checkConnectionAndSetupModel()
            }
        }
    }
    
    func switchGender() {
        catalogModel?.isSwitchGender(completion: {
            self.catalogModel?.updateLocalGender()
            self.catalogModel?.fetchGenderData()
        })
    }
    
    func fetchGenderData() {
        startLoad()
        catalogModel?.fetchGenderData()
    }
}


// MARK: - CatalogModelOutput
extension CatalogController:CatalogModelOutput {
    
    func updateData(data: [PreviewSection]?, error: Error?) {
        stopLoad()
        switch stateDataSource {
            
        case .firstDataUpdate:
            guard let data = data, error == nil else {
                navController?.showPlaceholder()
                catalogModel?.deleteGenderListeners()
                showErrorAlert(message: error?.localizedDescription ?? "Something went wrong!", state: .followingDataUpdate) {
                    self.fetchGenderData()
                } cancelActionHandler: {
                    self.stateDataSource = .followingDataUpdate
                }
                return
            }
            navController?.hiddenPlaceholder()
            stateDataSource = .followingDataUpdate
            dataSource = data
            
        case .followingDataUpdate:
            guard let data = data, error == nil else {
                catalogModel?.deleteGenderListeners()
                self.showErrorAlert(message: error?.localizedDescription ?? "Something went wrong!", state: .followingDataUpdate) {
                    self.fetchGenderData()
                    /// в этом блоке мы проверяем откуда мы пришли с ошибкой и откатываемся назад
                } cancelActionHandler: {
                    /// При нажатии на cancel мы всегда теряем observer
                    /// Мы должны проверять в viewWillAppeare есть ли наблюдатель активный в массиве
                    /// Если да то мы выпоняем switchGender() иначе forceFetchGenderData()
                    
                    switch self.stateCancelAlert {
                        
                    case .segmentControlFailed:
                        self.catalogModel?.toggleGlobalAndLocalGender()
                        NotificationCenter.default.post(name: NSNotification.Name("SwitchSegmentControlHeaderCatalogNotification"), object: nil)
                        self.stateCancelAlert = .switchGenderFailed
                    case .switchGenderFailed:
                        self.catalogModel?.toggleLocalGender()
                        break
                    case .forcedUpdateDataFailed:
                        break
                    }
                }
                return
            }
            stateCancelAlert = .switchGenderFailed
            dataSource = data
        }
    }
}

// MARK: - HeaderMallSectionDelegate
extension CatalogController:HeaderCatalogSectionDelegate {
    func didSelectSegmentControl(gender: String) {
        stateCancelAlert = .segmentControlFailed
        catalogModel?.setGlobalGender(gender: gender)
        switchGender()
    }
}


// MARK: - UICollectionViewDataSource + UICollectionViewDelegate + UICollectionViewDelegateFlowLayout
extension CatalogController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MallCell.reuseID, for: indexPath) as? MallCell else { return UICollectionViewCell() }
            cell.configureCell(model: Item(mall: nil, shop: nil, popularProduct: nil), isHiddenTitle: false)
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCatalogSection.headerIdentifier, for: indexPath) as! HeaderCatalogSection
        headerView.delegate = self
        headerView.configureCell(gender: catalogModel?.returnLocalGender() ?? "Man")
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let header = HeaderCatalogSection()
        /// Вычисляет размер header, который был бы достаточно большим для отображения всего его содержимого, используя текущие ограничения автоматического расположения. UIView.layoutFittingCompressedSize говорит системе, что вы хотите минимальный возможный размер.
        let headerSize = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        return headerSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// maby pattern Category?
    }
}
