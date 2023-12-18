//
//  MallCell.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 18.12.23.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI

class MallCell: UICollectionViewCell {
    
    static var reuseID: String = "MallCell"
    var storage: Storage!
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
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
        imageView.sd_cancelCurrentImageLoad()
        imageView.image = nil
    }
}

// MARK: - Setting Views
private extension MallCell {
    func setupView() {
        addSubview(imageView)
        addSubview(nameMall)
        setupConstraints()
        storage = Storage.storage()
    }
}

// MARK: - Setting
extension MallCell {
    func configureCell(model:Item) {
        
        if let firstRef = model.mall?.refImage {
            let urlRef = storage.reference(forURL: firstRef)
            self.imageView.sd_setImage(with: urlRef, placeholderImage: UIImage(named: "DefaultImage"))
        } else {
            imageView.image = UIImage(named: "DefaultImage")
        }
        nameMall.text = model.mall?.name
    }
}

// MARK: - Layout
private extension MallCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: topAnchor),
                                     imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     nameMall.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                                     nameMall.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
                                    ])
    }
}




// MARK: - Tresh
