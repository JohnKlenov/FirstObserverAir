//
//  ShopCell.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 18.12.23.
//

import UIKit
//import FirebaseStorage
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
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 1
        label.tintColor = R.Colors.label
        label.isHidden = true
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
        imageView.isHidden = false
        nameLabel.isHidden = true
//        imageView.sd_cancelCurrentImageLoad()
//        imageView.image = nil
    }
}


// MARK: - Setting Views
private extension ShopCell {
    func setupView() {
        contentView.backgroundColor = R.Colors.secondarySystemBackground
        contentView.addSubview(nameLabel)
        contentView.addSubview(imageView)
        setupConstraints()
        storage = Storage.storage()
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}

// MARK: - Setting
extension ShopCell {
    func configureCell(model: Item) {
        let placeholderImage = UIImage(systemName: "photo")
        
        if let urlString = model.shop?.refImage {
            let urlRef = storage.reference(forURL: urlString)
            imageView.sd_setImage(with: urlRef, placeholderImage: placeholderImage) { (image, error, cacheType, url) in
                guard let image = image, error == nil else {
                    
                    // Обработка ошибок
                    self.imageView.image = placeholderImage
                    print("Returned message for analytic FB Crashlytics error ShopCell - \(String(describing: error?.localizedDescription))")
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
            imageView.isHidden = true
            nameLabel.isHidden = false
            nameLabel.text = model.shop?.name
        }
    }
}

// MARK: - Layout
private extension ShopCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4), imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4), imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4), imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)])
        
        NSLayoutConstraint.activate([nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor), nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5), nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5)])
    }
}
