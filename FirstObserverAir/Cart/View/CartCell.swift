//
//  CartCell.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 13.02.24.
//

import UIKit
import FirebaseStorageUI

final class CartCell: UITableViewCell {

    static var reuseID: String = "CartCell"
    var storage: Storage!
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.secondarySystemBackground
        view.layer.cornerRadius = 10
        return view
    }()
    
    let imageCell: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 4
        image.backgroundColor = .tertiarySystemBackground
        image.clipsToBounds = true
        image.tintColor = R.Colors.label
        return image
    }()
    
    let brandLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.backgroundColor = .clear
        label.textColor = R.Colors.label
        label.numberOfLines = 1
        return label
    }()
    
    let modelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13)
        label.backgroundColor = .clear
        label.textColor = R.Colors.secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    let shopLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.backgroundColor = .clear
        label.textColor = R.Colors.systemPurple
        label.numberOfLines = 1
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.backgroundColor = .clear
        label.textColor = R.Colors.label
        label.numberOfLines = 0
        return label
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 1
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit CartCell")
    }
}

// MARK: - Setting Views
private extension CartCell {
    func setupView() {
        containerView.addSubview(imageCell)
        containerView.addSubview(stackView)
        contentView.addSubview(containerView)
        configureStackView()
        setupConstraints()
        storage = Storage.storage()
    }
}

// MARK: - Setting
extension CartCell {
    
    func configureCell(model: ProductItem) {
        let configuration = UIImage.SymbolConfiguration(weight: .ultraLight)
        let placeholderImage = UIImage(systemName: "xmark", withConfiguration: configuration)
        placeholderImage?.withRenderingMode(.alwaysTemplate)

        if let firstRef = model.refImage?.first {
            let urlRef = storage.reference(forURL: firstRef)
            self.imageCell.sd_setImage(with: urlRef, placeholderImage: nil)
        } else {
            if let _ = model.isNotAvailoble {
                imageCell.image = placeholderImage
            } else {
                imageCell.image = nil
            }
        }
        brandLabel.text = model.brand
        modelLabel.text = model.model
        shopLabel.text = model.shops?.first
        priceLabel.text = "\(model.price ?? 0) BYN"
    }

    private func configureStackView() {
        [brandLabel, modelLabel, shopLabel, priceLabel].forEach { stackView.addArrangedSubview($0) }
    }
}

// MARK: - Layout
private extension CartCell {
    private func setupConstraints() {
        
        let topContainerCnstr = containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
        topContainerCnstr.priority = UILayoutPriority(999)
        topContainerCnstr.isActive = true
        
        let bottomContainerCnstr = containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        bottomContainerCnstr.priority = UILayoutPriority(999)
        bottomContainerCnstr.isActive = true
        
        let leadingContainerCnstr = containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5)
        leadingContainerCnstr.priority = UILayoutPriority(999)
        leadingContainerCnstr.isActive = true
        
        let trailingContainerCnstr = containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        trailingContainerCnstr.priority = UILayoutPriority(999)
        trailingContainerCnstr.isActive = true
        
        let topImageViewCnstr = imageCell.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5)
        topImageViewCnstr.priority = UILayoutPriority(999)
        topImageViewCnstr.isActive = true
        
        let leadingImageViewCnstr = imageCell.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5)
        leadingImageViewCnstr.isActive = true
        
        let widthImageViewCnstr = imageCell.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1/4)
        widthImageViewCnstr.isActive = true
        
        let heightImageViewCnstr = imageCell.heightAnchor.constraint(equalTo: imageCell.widthAnchor)
        heightImageViewCnstr.isActive = true
        
        let bottomImageViewCnstr = imageCell.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5)
        bottomImageViewCnstr.priority = UILayoutPriority(999)
        bottomImageViewCnstr.isActive = true
        
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: imageCell.topAnchor), stackView.leadingAnchor.constraint(equalTo: imageCell.trailingAnchor, constant: 10), stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)])
    }
}




// MARK: - Trash

   
    

//    func configureCell(model: ProductItem) {
//        SDImageCache.shared.removeImage(forKey: <#T##String?#>) {
//            <#code#>
//        }
//        let placeholderImage = UIImage(systemName: "photo")
//        placeholderImage?.withRenderingMode(.alwaysTemplate)
//        let outdatedImage = UIImage(named: "swift") // Загрузите ваше изображение "устарело" здесь
//
//        if let firstRef = model.refImage?.first {
//            let urlRef = storage.reference(forURL: firstRef)
//            self.imageCell.sd_setImage(with: urlRef, placeholderImage: placeholderImage) { image, error, cacheType, storageRef in
//                if let error = error as NSError? {
//                    if error.code == StorageErrorCode.objectNotFound.rawValue {
//                        print("StorageErrorCode.objectNotFound.rawValue - \(error.localizedDescription)")
//                        // Если объект не найден, установите изображение как "устарело"
//                        self.imageCell.image = outdatedImage
//                    } else {
//                        print("another errors - \(error.localizedDescription)")
//                        // Обработка других ошибок
//                    }
//                } else {
//                    print("error - \(String(describing: error?.localizedDescription))")
//                }
//            }
//        } else {
//            imageCell.image = placeholderImage
//        }
//        brandLabel.text = model.brand
//        modelLabel.text = model.model
//        shopLabel.text = model.shops?.first
//        priceLabel.text = "\(model.price ?? 0) BYN"
//    }

//    func configureCell(model: ProductItem) {
//        let placeholderImage = UIImage(systemName: "photo")
//        placeholderImage?.withRenderingMode(.alwaysTemplate)
//        let outdatedImage = UIImage(systemName: "swift") // Загрузите ваше изображение "устарело" здесь
//        print("configureCell")
//        CacheManager.cacheImageRemoveMemoryAndDisk(imageView: imageCell)
//
//        if let firstRef = model.refImage?.first {
//            let urlRef = storage.reference(forURL: firstRef)
//            imageCell.sd_setImage(with: urlRef, maxImageSize: UInt64.max, placeholderImage: nil, options: .refreshCached) { image, error, cache, storageRef in
//                print("imageCell.sd_setImage")
//                if let error = error as NSError? {
//                    if error.code == StorageErrorCode.objectNotFound.rawValue {
//                        print("StorageErrorCode.objectNotFound.rawValue - \(error.localizedDescription)")
//                        // Если объект не найден, установите изображение как "устарело"
//                        self.imageCell.image = outdatedImage
//                    } else {
//                        print("another errors - \(error.localizedDescription)")
//                        // Обработка других ошибок
//                    }
//                } else {
//                    print("error - \(String(describing: error?.localizedDescription))")
//                }
//            }
//        } else {
//            imageCell.image = nil
//        }
//        brandLabel.text = model.brand
//        modelLabel.text = model.model
//        shopLabel.text = model.shops?.first
//        priceLabel.text = "\(model.price ?? 0) BYN"
//
//    }
