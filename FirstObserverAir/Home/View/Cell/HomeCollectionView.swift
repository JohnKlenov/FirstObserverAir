//
//  HomeCollectionView.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 22.12.23.
//

import UIKit

final class HomeCollectionView: UICollectionView {
    
    private var data:[SectionModel] = [] {
        didSet {
            reload()
        }
    }

    private var gender: String
    
    weak var headerMallDelegate: HeaderMallSectionDelegate?
    weak var headerShopDelegate: HeaderShopSectionDelegate?

    private var collectionViewDataSource: UICollectionViewDiffableDataSource<SectionModel, Item>?
    
    init(gender: String) {
        self.gender = gender
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        let layout = self.createLayout()
        self.collectionViewLayout = layout
        self.setupView()
    }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}

// MARK: - Setting Views
private extension HomeCollectionView {
    func setupView() {
        backgroundColor = .clear
        createDataSource()
        registerView()
    }
}

// MARK: - Setting CollectionView
private extension HomeCollectionView {
    
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let section = self.data[sectionIndex]
            
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

        collectionViewDataSource = UICollectionViewDiffableDataSource<SectionModel, Item>(collectionView: self, cellProvider: { collectionView, indexPath, cellData in
            switch self.data[indexPath.section].section {
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
                cell?.delegate = self.headerMallDelegate
                cell?.configureCell(title: R.Strings.TabBarController.Home.ViewsHome.headerMallView, gender: self.gender)
                return cell
            } else if kind == "HeaderShop" {
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: HeaderShopSection.headerIdentifier, withReuseIdentifier: HeaderShopSection.headerIdentifier, for: IndexPath) as? HeaderShopSection
                cell?.delegate = self.headerShopDelegate
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
    
    func registerView() {
        register(MallCell.self, forCellWithReuseIdentifier: MallCell.reuseID)
        register(ShopCell.self, forCellWithReuseIdentifier: ShopCell.reuseID)
        register(PopProductCell.self, forCellWithReuseIdentifier: PopProductCell.reuseID)
        register(HeaderMallSection.self, forSupplementaryViewOfKind: "HeaderMall", withReuseIdentifier: HeaderMallSection.headerIdentifier)
        register(HeaderShopSection.self, forSupplementaryViewOfKind: "HeaderShop", withReuseIdentifier: HeaderShopSection.headerIdentifier)
        register(HeaderPopProductSection.self, forSupplementaryViewOfKind: "HeaderPopProduct", withReuseIdentifier: HeaderPopProductSection.headerIdentifier)
    }
    
    func reload() {

        var snapshot = NSDiffableDataSourceSnapshot<SectionModel, Item>()
        snapshot.appendSections(data)

        for section in data {
            snapshot.appendItems(section.items, toSection: section)
        }
        collectionViewDataSource?.apply(snapshot)
       
    }
}

// MARK: - Setting DataSource
extension HomeCollectionView {
    func reloadData(data: [SectionModel]) {
        self.data = data
    }
}
