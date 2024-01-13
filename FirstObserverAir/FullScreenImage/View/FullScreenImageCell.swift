//
//  FullScreenImageCell.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 12.01.24.
//

import UIKit
import FirebaseStorageUI


final class FullScreenImageCell: UICollectionViewCell {
    
    static var reuseID: String = "FullScreenImageCell"
    var storage: Storage!
    private var scrollView: ImageScrollView!
    
    
    let imageView: UIImageView = {
        let image = UIImageView()
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        imageView.sd_cancelCurrentImageLoad()
//        imageView.image = nil
    }
    
    func configureCell(refImage:String) {
        
        let refStorage = storage.reference(forURL: refImage)
        imageView.sd_setImage(with: refStorage, placeholderImage: UIImage(named: "DefaultImage")) { (image, error, cacheType, ref) in
            if let image = image {
                self.scrollView.set(image:image)
            }
        }
        scrollView.set(image: imageView.image ?? UIImage())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit FullScreenImageCell")
    }
}

// MARK: - Setting Views
private extension FullScreenImageCell {
    func setupView() {
        storage = Storage.storage()
        scrollView = ImageScrollView(frame: contentView.bounds)
        contentView.addSubview(scrollView)
        setupConstraints()
    }
}

// MARK: - Layout
private extension FullScreenImageCell {
    func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
