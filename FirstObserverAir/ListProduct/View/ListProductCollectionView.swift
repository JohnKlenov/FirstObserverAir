//
//  ListProductCollectionView.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 27.12.23.
//

import UIKit

final class ListProductCollectionView: UICollectionView {
    
    private var data:[ProductItem] = [] {
        didSet {
            reloadData()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
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
private extension ListProductCollectionView {
    func setupView() {
        backgroundColor = .clear
//        createDataSource()
//        registerView()
    }
}

// MARK: - Setting CollectionView
private extension ListProductCollectionView {
    
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            return self.productSection()
        }
    return layout
    }
    
    func productSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(10), trailing: nil, bottom: nil)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
        return section
    }
    
    func registerView() {

    }
}

// MARK: - Setting DataSource
extension ListProductCollectionView {
    func updateData(data: [ProductItem]) {
        self.data = data
    }
}

        
