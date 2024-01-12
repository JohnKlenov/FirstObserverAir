//
//  FullScreenImageController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 12.01.24.
//

import UIKit

final class FullScreenImageController: UIViewController {

    private var imageProductCollectionView : UICollectionView!
    
    private let xmarkImage: UIImageView = {
        let view = UIImageView()
        if let image = R.Images.FullScreenImageController.xmark {
            let tintableImage = image.withRenderingMode(.alwaysTemplate)
            view.image = tintableImage
        }
        view.tintColor = R.Colors.systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let xmarkTapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.numberOfTapsRequired = 1
        return recognizer
    }()
    
    private let pagesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = R.Colors.systemGray
        label.backgroundColor = .clear
        return label
    }()
    
    var productImages: [String] = []
    var indexPath = IndexPath(item: 0, section: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = R.Colors.backgroundBlack
        view.backgroundColor = R.Colors.systemBackground
        pagesLabel.text = "\(indexPath.row + 1)/\(productImages.count)"

        setupCollectionView()
        xmarkTapGestureRecognizer.addTarget(self, action: #selector(didTapDeleteImage(_:)))
        xmarkImage.addGestureRecognizer(xmarkTapGestureRecognizer)
        view.addSubview(xmarkImage)
        view.addSubview(pagesLabel)
        
        setupConstraints()
        imageProductCollectionView.performBatchUpdates(nil) { (_) in
            self.imageProductCollectionView.scrollToItem(at: self.indexPath, at: .centeredHorizontally, animated: false)
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == imageProductCollectionView {
            let currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            pagesLabel.text = "\(currentPage + 1)/\(productImages.count)"
        }
    }
    
    @objc func didTapDeleteImage(_ gestureRcognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
   
    
    
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal

        imageProductCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        imageProductCollectionView.delegate = self
        imageProductCollectionView.dataSource = self
        imageProductCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imageProductCollectionView.register(FullScreenImageCell.self, forCellWithReuseIdentifier: FullScreenImageCell.reuseID)

        imageProductCollectionView.backgroundColor = .clear
        imageProductCollectionView.isPagingEnabled = true
        imageProductCollectionView.showsVerticalScrollIndicator = false
        imageProductCollectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(imageProductCollectionView)
    }
    
    private func setupConstraints() {
        imageProductCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        imageProductCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        imageProductCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        imageProductCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        xmarkImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10).isActive = true
        xmarkImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        xmarkImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        xmarkImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        pagesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        pagesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10).isActive = true
    }
}


extension FullScreenImageController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullScreenImageCell", for: indexPath) as! FullScreenImageCell
        cell.configureCell(refImage: productImages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 10, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
}
