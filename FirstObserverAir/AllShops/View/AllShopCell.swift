//
//  ShopCell.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 26.12.23.
//

import UIKit
import FirebaseStorageUI

class AllShopCell: UITableViewCell {

    static var reuseID: String = "AllShopCell"
    var storage: Storage!
    
    let imageCell: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 4
        image.clipsToBounds = true
        image.tintColor = R.Colors.label
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 2
        label.tintColor = R.Colors.label
        label.isHidden = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.isHidden = false
        nameLabel.isHidden = true
    }
}

// MARK: - Setting Views
private extension AllShopCell {
    func setupView() {
//        contentView.backgroundColor = R.Colors.secondarySystemBackground
        contentView.addSubview(nameLabel)
        contentView.addSubview(imageCell)
        setupConstraints()
        storage = Storage.storage()
    }
}

// MARK: - Setting
extension AllShopCell {
    func configureCell(model: Item) {
        if let urlString = model.shop?.refImage {
            let urlRef = storage.reference(forURL: urlString)
            let placeholderImage = UIImage(systemName: "photo")
            
            imageCell.sd_setImage(with: urlRef, placeholderImage: placeholderImage) { (image, error, cacheType, url) in
                guard let image = image, error == nil else {
                    
                    // Обработка ошибок
                    self.imageCell.image = UIImage(systemName: "photo")
                    print("Returned message for analytic FB Crashlytics error AllShopCell - \(String(describing: error?.localizedDescription))")
                    return
                }
                // Настройка цвета изображения в зависимости от текущей темы
                if #available(iOS 13.0, *) {
                    let tintableImage = image.withRenderingMode(.alwaysTemplate)
                    self.imageCell.image = tintableImage
                } else {
                    self.imageCell.image = image
                }
            }
        }else {
            imageCell.isHidden = true
            nameLabel.isHidden = false
            nameLabel.text = model.shop?.name
        }
    }
}

// MARK: - Layout
private extension AllShopCell {
    func setupConstraints() {
        let topImageViewCnstr = imageCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
        topImageViewCnstr.priority = UILayoutPriority(999)
        topImageViewCnstr.isActive = true

        let leadingImageViewCnstr = imageCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        leadingImageViewCnstr.isActive = true

        let widthImageViewCnstr = imageCell.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/5)
        widthImageViewCnstr.isActive = true

        let heightImageViewCnstr = imageCell.heightAnchor.constraint(equalTo: imageCell.widthAnchor)
        heightImageViewCnstr.isActive = true

        let bottomImageViewCnstr = imageCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        bottomImageViewCnstr.priority = UILayoutPriority(999)
        bottomImageViewCnstr.isActive = true
        
        NSLayoutConstraint.activate([nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor), nameLabel.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor, constant: 5)])
    }
}
