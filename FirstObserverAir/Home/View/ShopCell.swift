//
//  ShopCell.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 18.12.23.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI

class ShopCell: UICollectionViewCell {
    
    static var reuseID: String = "ShopCell"
    var storage: Storage!
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = R.Colors.label
        return image
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
private extension ShopCell {
    func setupView() {
        backgroundColor = R.Colors.secondarySystemBackground
        addSubview(imageView)
        setupConstraints()
        storage = Storage.storage()
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}

// MARK: - Setting
extension ShopCell {
    func configureCell(model: Item) {
        
        if let urlString = model.shop?.refImage {
            let urlRef = storage.reference(forURL: urlString)
            let placeholderImage = UIImage(named: "DefaultImage")
            
            imageView.sd_setImage(with: urlRef, placeholderImage: placeholderImage) { (image, error, cacheType, url) in
                guard let image = image else {
                    // Обработка ошибок
                    return
                }
                // Настройка цвета изображения в зависимости от текущей темы
                if #available(iOS 13.0, *) {
                    let tintableImage = image.withRenderingMode(.alwaysTemplate)
                    self.imageView.image = tintableImage
                } else {
                    self.imageView.image = image
                }
            }
            
        }else {
            imageView.image = UIImage(named: "DefaultImage")
            
        }
    }
}

// MARK: - Layout
private extension ShopCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: topAnchor, constant: 4), imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4), imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4), imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)])
    }
}
