//
//  MallsController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 26.11.23.
//

import UIKit


final class MallsController: UIViewController {
    
//    var malls:SectionModel
//    var gender: String
//
//    private lazy var collectionView: UICollectionView = {
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height) / 4)
//        layout.minimumInteritemSpacing = 15
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .clear
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(MallCell.self, forCellWithReuseIdentifier: MallCell.reuseID)
//
//        return collectionView
//    }()
//
//    init(malls:SectionModel, currentGender:String) {
//        self.malls = malls
//        self.gender = currentGender
//        super.init(nibName: nil, bundle: nil)
//        setupView()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

//// MARK: - Setting Views
//private extension MallsController {
//    func setupView() {
//        title = "AllMalls"
//        view.backgroundColor = R.Colors.systemBackground
//        setupCollectionView()
//        setupConstraints()
//    }
//}
//
//// MARK: - Setting
//private extension MallsController {
//    func setupCollectionView() {
//        view.addSubview(collectionView)
//    }
//}
//
//// MARK: - Layout
//private extension MallsController {
//    func setupConstraints() {
//        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0), collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor), collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
//    }
//}
//
//// MARK: - UICollectionViewDataSource + UICollectionViewDelegate + UICollectionViewDelegateFlowLayout
//extension MallsController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return malls.items.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MallCell.reuseID, for: indexPath) as? MallCell else { return UICollectionViewCell() }
//        cell.configureCell(model: malls.items[indexPath.row], isHiddenTitle: false)
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("\(indexPath.row)")
//    }
//}
