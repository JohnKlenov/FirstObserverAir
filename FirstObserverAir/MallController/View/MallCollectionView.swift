//
//  MallCollectionView.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 18.01.24.
//

import UIKit

final class MallCollectionView: UICollectionView {
    
    private var data:[SectionModel] = [] {
        didSet {
            reload()
        }
    }
    weak var footerMallDelegate: PageFooterMallDelegate?
    var currentPage: Int?

    private var collectionViewDataSource: UICollectionViewDiffableDataSource<SectionModel, Item>?
    
    init() {
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
private extension MallCollectionView {
    func setupView() {
        backgroundColor = .clear
        createDataSource()
        registerView()
    }
}

// MARK: - Setting CollectionView
private extension MallCollectionView {
    
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let section = self?.data[sectionIndex]
            
            switch section?.section {
            case "Mall":
                return self?.mallSections()
            case "Shop":
                return self?.shopSection()
            default:
                return self?.defaultSection()
            }
        }
    return layout
    }
    
    func mallSections() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.55))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        //        groupPagingCentered
        //        section.orthogonalScrollingBehavior = .paging
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        let sizeFooter = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sizeFooter, elementKind: "FooterMall", alignment: .bottom)
        section.boundarySupplementaryItems = [footer]
        
        section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, offset, env) -> Void in
            guard let self = self else {return}
            let newPage = visibleItems.last?.indexPath.row ?? 0
            if newPage != self.currentPage {
                self.currentPage = newPage
                self.footerMallDelegate?.currentPage(index: newPage)
            }
        }
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
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sizeHeader, elementKind: "HeaderBrands", alignment: .top)
        header.pinToVisibleBounds = true
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
    
    func createDataSource() {

        collectionViewDataSource = UICollectionViewDiffableDataSource<SectionModel, Item>(collectionView: self, cellProvider: { collectionView, indexPath, cellData in
            switch self.data[indexPath.section].section {
            case "Mall":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MallCell.reuseID, for: indexPath) as? MallCell
                cell?.configureCell(model: cellData, isHiddenTitle: true)
                return cell
            case "Shop":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandCellMallVC.reuseID, for: indexPath) as? BrandCellMallVC
                cell?.configureCell(model: cellData)
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandCellMallVC.reuseID, for: indexPath) as? BrandCellMallVC
                cell?.configureCell(model: cellData)
                return cell
            }
        })
        
        collectionViewDataSource?.supplementaryViewProvider = { collectionView, kind, IndexPath in
            
            if kind == "FooterMall" {
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: PagingSectionFooterView.footerIdentifier, withReuseIdentifier: PagingSectionFooterView.footerIdentifier, for: IndexPath) as? PagingSectionFooterView
                let itemCount = self.collectionViewDataSource?.snapshot().numberOfItems(inSection: self.data[IndexPath.section])
                footerView?.configure(with: itemCount ?? 0)
                self.footerMallDelegate = footerView
                return footerView
            } else if kind == "HeaderBrands" {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: HeaderBrandsMallView.headerIdentifier, withReuseIdentifier: HeaderBrandsMallView.headerIdentifier, for: IndexPath) as? HeaderBrandsMallView
                headerView?.configureCell(title: "Brands for mall")
                return headerView
            } else {
                return nil
            }
        }
    }
    
    func registerView() {
        register(MallCell.self, forCellWithReuseIdentifier: MallCell.reuseID)
        register(BrandCellMallVC.self, forCellWithReuseIdentifier: BrandCellMallVC.reuseID)
        register(PagingSectionFooterView.self, forSupplementaryViewOfKind: "FooterMall", withReuseIdentifier: PagingSectionFooterView.footerIdentifier)
        register(HeaderBrandsMallView.self, forSupplementaryViewOfKind: "HeaderBrands", withReuseIdentifier: HeaderBrandsMallView.headerIdentifier)
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
extension MallCollectionView {
    func reloadData(data: [SectionModel]) {
        self.data = data
    }
}
