//
//  ImageCell.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 2.01.24.
//

import UIKit
import FirebaseStorageUI

final class ImageCell: UICollectionViewCell {
    
    static var reuseID: String = "ImageCell"
    private var storage: Storage!
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        imageView.sd_cancelCurrentImageLoad()
//        imageView.image = nil
    }
    
    func configureCell(refImage:String) {
        let refStorage = storage.reference(forURL: refImage)
        imageView.sd_setImage(with: refStorage, placeholderImage: UIImage(named: "DefaultImage"))
    }
}

// MARK: - Setting Views
private extension ImageCell {
    func setupView() {
        storage = Storage.storage()
        contentView.addSubview(imageView)
        setupConstraints()
    }
}

// MARK: - Layout
private extension ImageCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                     imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }
}
