//
//  ListProductCollectionView.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 27.12.23.
//

protocol ListProductCollectionDelegate: AnyObject {
    func didSelectCell(_ index:Int)
}

import UIKit

final class ListProductCollectionView: UICollectionView {
    
    private var data:[ProductItem] = [] {
        didSet {
            reloadData()
        }
    }
    
    weak var delegateListProduct: ListProductCollectionDelegate?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        let layout = self.createLayout()
        self.collectionViewLayout = layout
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit ListProductCollectionView")
    }
}

// MARK: - Setting Views
private extension ListProductCollectionView {
    func setupView() {
        backgroundColor = .clear
        delegate = self
        dataSource = self
        registerView()
    }
}

// MARK: - Setting CollectionView
private extension ListProductCollectionView {
    
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            return self?.productSection()
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
        register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseID)
    }
}

// MARK: - Setting DataSource
extension ListProductCollectionView {
    func updateData(data: [ProductItem]) {
        self.data = data
    }
}

// MARK: UICollectionViewDelegate + UICollectionViewDataSource
extension ListProductCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.reuseID, for: indexPath) as? ProductCell else {
            print("Returned message for analytic FB Crashlytics error ListProductCollectionView")
            return UICollectionViewCell()
        }
        let product = data[indexPath.item]
        cell.configureCell(model: product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegateListProduct?.didSelectCell(indexPath.row)
    }
}
