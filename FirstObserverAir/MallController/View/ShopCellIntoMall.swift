//
//  ShopCellIntoMall.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 31.01.24.
//

import UIKit
import FirebaseStorage

final class ShopCellIntoMall: UICollectionViewCell {
    
    static var reuseID: String = "ShopCellIntoMall"
    private var storage: Storage!
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemRed
        return view
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 10
        image.tintColor = R.Colors.label
        image.backgroundColor = R.Colors.secondarySystemBackground
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    private let nameShopLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = R.Colors.label
        label.backgroundColor = R.Colors.secondarySystemBackground
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()
    
    private let floorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = R.Colors.secondaryLabel
        label.backgroundColor = .clear
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.isHidden = false
        nameShopLabel.isHidden = true
        //        imageView.sd_cancelCurrentImageLoad()
        //        imageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit ShopCellIntoMall")
    }
}

// MARK: - Setting Views
private extension ShopCellIntoMall {
    func setupView() {
        contentView.backgroundColor = .clear
        storage = Storage.storage()
        contentView.addSubview(imageView)
        contentView.addSubview(nameShopLabel)
        contentView.addSubview(floorLabel)
        setupConstraints()
    }
}

// MARK: - Setting
extension ShopCellIntoMall {
    func configureCell(model: Item) {
        let placeholderImage = UIImage(systemName: "photo")
        if let urlString = model.shop?.logo {
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
            nameShopLabel.isHidden = false
            nameShopLabel.text = model.shop?.name
        }
        
        if let floor = model.shop?.floor {
            floorLabel.text = floor
        }
    }
}

// MARK: - Layout
private extension ShopCellIntoMall {
    func setupConstraints() {
        // Определение ограничений для imageView, floorLabel и nameShopLabel
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            floorLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            floorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            floorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            nameShopLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameShopLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameShopLabel.heightAnchor.constraint(equalTo: nameShopLabel.widthAnchor)
        ])
        
        // Определение ограничения для верхнего края imageView
        let imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: contentView.topAnchor)
        imageViewTopConstraint.priority = UILayoutPriority(999)
        imageViewTopConstraint.isActive = true
        
        // Определение ограничения для верхнего края nameShopLabel
        let nameShopTopConstraint = nameShopLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        nameShopTopConstraint.priority = UILayoutPriority(999)
        nameShopTopConstraint.isActive = true
        
        // Определение ограничения для нижнего края floorLabel
        let floorLabelBottomConstraint = floorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        floorLabelBottomConstraint.priority = UILayoutPriority(999)
        floorLabelBottomConstraint.isActive = true
    }
}

