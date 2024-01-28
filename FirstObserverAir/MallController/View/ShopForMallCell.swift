//
//  ShopForMallCell.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 18.01.24.
//

import UIKit
import FirebaseStorageUI


class BrandCellMallVC: UICollectionViewCell {
    
    static var reuseID: String = "BrandCell"
    var storage: Storage!
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemRed
        return view
    }()
    
    let imageView: UIImageView = {
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
    
    let nameShopLabel: UILabel = {
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
    
    let floorLabel: UILabel = {
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
        contentView.backgroundColor = .clear
        storage = Storage.storage()
        contentView.addSubview(imageView)
        contentView.addSubview(nameShopLabel)
        contentView.addSubview(floorLabel)
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.isHidden = false
        nameShopLabel.isHidden = true
        
//        imageView.sd_cancelCurrentImageLoad()
//        imageView.image = nil
    }
    
    private func setupConstraints() {
        
       
        // Определение ограничений для imageView, floorLabel и nameShopLabel
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            floorLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            floorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            floorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            nameShopLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//class BrandCellMallVC: UICollectionViewCell {
//
//    static var reuseID: String = "BrandCell"
//    var storage: Storage!
//
//    let imageView: UIImageView = {
//        let image = UIImageView()
//        image.translatesAutoresizingMaskIntoConstraints = false
//        image.contentMode = .scaleAspectFit
//        image.layer.cornerRadius = 10
//        image.clipsToBounds = true
//        return image
//    }()
//
//    let nameBrandLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .left
//        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
//        label.textColor = R.Colors.systemPurple
//        label.backgroundColor = .clear
//        return label
//    }()
//
//    let floorLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "3 floor"
//        label.textAlignment = .left
//        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
//        label.textColor = R.Colors.secondaryLabel
//        label.backgroundColor = .clear
//        return label
//    }()
//
//    let stackViewForLabel: UIStackView = {
//        let stack = UIStackView()
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.axis = .vertical
//        stack.distribution = .fill
//        stack.spacing = 0
//        return stack
//    }()
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configureStackView()
//        addSubview(imageView)
//        addSubview(stackViewForLabel)
//        setupConstraints()
//        storage = Storage.storage()
//        backgroundColor = .clear
//    }
//
//    private func configureStackView() {
//
//        let arrayViews = [nameBrandLabel, floorLabel]
//        arrayViews.forEach { view in
//            stackViewForLabel.addArrangedSubview(view)
//
//        }
//    }
//
//    private func setupConstraints() {
//
//        let topImageViewCnstr = imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10)
//        topImageViewCnstr.priority = UILayoutPriority(999)
//        topImageViewCnstr.isActive = true
//
//        let trailingImageViewCnstr = imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
//        trailingImageViewCnstr.isActive = true
//
//        let leadingImageViewCnstr = imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
//        leadingImageViewCnstr.isActive = true
//
//        let heightImageViewCnstr = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1)
//        heightImageViewCnstr.isActive = true
//
//        let topStackCnstr = stackViewForLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5)
//        topStackCnstr.isActive = true
//
//        let trailingStackCnstr = stackViewForLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
//        trailingStackCnstr.isActive = true
//
//        let leadingStackCnstr = stackViewForLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
//        leadingStackCnstr.isActive = true
//
//        let bottomStackCnstr = stackViewForLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
//        bottomStackCnstr.priority = UILayoutPriority(999)
//        bottomStackCnstr.isActive = true
//    }
//
//    func configureCell(model: Item) {
//
//        if let firstRef = model.shop?.refImage {
//            let urlRef = storage.reference(forURL: firstRef)
//
//            self.imageView.sd_setImage(with: urlRef, placeholderImage: UIImage(named: "DefaultImage"))
//        } else {
//            imageView.image = UIImage(named: "DefaultImage")
//        }
//        nameBrandLabel.text = model.shop?.name
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//}
