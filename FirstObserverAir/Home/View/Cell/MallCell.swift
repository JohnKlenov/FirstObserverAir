//
//  MallCell.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 18.12.23.
//

import UIKit
import FirebaseStorageUI

class MallCell: UICollectionViewCell {
    
    static var reuseID: String = "MallCell"
    var storage: Storage!
    
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.tintColor = R.Colors.label
        return image
    }()
    
    let nameMall: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = R.Colors.labelWhite
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
//        imageView.sd_cancelCurrentImageLoad()
//        imageView.image = nil
    }
    deinit {
        print("deinit MallCell")
    }
}

// MARK: - Setting Views
private extension MallCell {
    func setupView() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameMall)
        layer.cornerRadius = 10
        clipsToBounds = true
        setupConstraints()
        storage = Storage.storage()
    }
}

// MARK: - Setting
extension MallCell {
    func configureCell(model:Item, isHiddenTitle:Bool) {
        nameMall.isHidden = isHiddenTitle
        let placeholderImage = UIImage(systemName: "photo")
        placeholderImage?.withRenderingMode(.alwaysTemplate)
        if let firstRef = model.mall?.refImage {
            let urlRef = storage.reference(forURL: firstRef)
            self.imageView.sd_setImage(with: urlRef, placeholderImage: placeholderImage)
        } else {
            imageView.image = placeholderImage
        }
        nameMall.text = model.mall?.name
    }
}

// MARK: - Layout
private extension MallCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                     imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                     nameMall.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                                     nameMall.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
                                    ])
    }
}




// MARK: - Tresh
