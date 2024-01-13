//
//  FullScreenImageController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 12.01.24.
//

import UIKit

final class FullScreenImageController: UIViewController {

    private var imageCollectionView : UICollectionView!
    
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
    
    private let xmarkTapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.numberOfTapsRequired = 1
        return recognizer
    }()
    
    private let pageNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = R.Colors.systemGray
        label.backgroundColor = .clear
        return label
    }()
    
    private var indexPath: IndexPath
    private var refImages: [String]
    
    init(refImages: [String], indexPath: IndexPath) {
        self.refImages = refImages
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit FullScreenImageController")
    }
    
    
}

// MARK: - Setting Views
private extension FullScreenImageController {
    
    func setupView() {
        view.backgroundColor = R.Colors.systemBackground
        pageNumberLabel.text = "\(indexPath.row + 1)/\(refImages.count)"
        setupCollectionView()
        setupXmarkTapGestureRecognizer()
        view.addSubview(xmarkImage)
        view.addSubview(pageNumberLabel)
        setupConstraints()
        /// этот код обновляет UICollectionView и прокручивает его к определенному элементу
        imageCollectionView.performBatchUpdates(nil) { [weak self] (_) in
            guard let self = self else { return }
            self.imageCollectionView.scrollToItem(at: self.indexPath , at: .centeredHorizontally, animated: false)
        }
    }
}

// MARK: - Setting
private extension FullScreenImageController {
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imageCollectionView.register(FullScreenImageCell.self, forCellWithReuseIdentifier: FullScreenImageCell.reuseID)
        
        imageCollectionView.backgroundColor = .clear
        imageCollectionView.isPagingEnabled = true
        imageCollectionView.showsVerticalScrollIndicator = false
        imageCollectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(imageCollectionView)
    }
    
    func setupXmarkTapGestureRecognizer() {
        xmarkTapGestureRecognizer.addTarget(self, action: #selector(didTapXmarkImage(_:)))
        xmarkImage.addGestureRecognizer(xmarkTapGestureRecognizer)
    }
}
    
// MARK: - Layout
private extension FullScreenImageController {
    func setupConstraints() {
        imageCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        imageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        imageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        imageCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        xmarkImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10).isActive = true
        xmarkImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        xmarkImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        xmarkImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        pageNumberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        pageNumberLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10).isActive = true
    }
}

// MARK: - UIScrollViewDelegate
extension FullScreenImageController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == imageCollectionView {
            /// xOffset будет содержать текущее горизонтальное смещение UIScrollView
            let currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            pageNumberLabel.text = "\(currentPage + 1)/\(refImages.count)"
        }
    }
}

// MARK: -  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension FullScreenImageController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        refImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullScreenImageCell", for: indexPath) as! FullScreenImageCell
        cell.configureCell(refImage: refImages[indexPath.row])
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

// MARK: - Selectors
private extension FullScreenImageController {
    @objc func didTapXmarkImage(_ gestureRcognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}
