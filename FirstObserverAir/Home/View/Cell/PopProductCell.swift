//
//  PopProductCell.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 18.12.23.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI

class PopProductCell: UICollectionViewCell {
    
    static var reuseID = "PopProductCell"
    var storage: Storage!
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
    }()
    
    let brandLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.backgroundColor = .clear
        label.textColor = R.Colors.label
        label.numberOfLines = 1
        return label
    }()
    
    let modelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.backgroundColor = .clear
        label.textColor = R.Colors.label
        label.numberOfLines = 1
        return label
    }()
    
    let shopLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.backgroundColor = .clear
        label.textColor = R.Colors.systemPurple
        label.numberOfLines = 1
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.backgroundColor = .clear
        label.textColor = R.Colors.label
        label.numberOfLines = 0
        return label
    }()
    
    let vStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 0
        return $0
    }(UIStackView())
    
    let hStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 0
        return stack
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
private extension PopProductCell {
    func setupView() {
        configureStackView()
        contentView.addSubview(imageView)
        contentView.addSubview(vStackView)
        setupConstraints()
        storage = Storage.storage()
        contentView.backgroundColor = R.Colors.secondarySystemBackground
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
    }
}

// MARK: - Setting
extension PopProductCell {
    
    private func configureStackView() {
        [shopLabel, priceLabel].forEach { view in
            hStackView.addArrangedSubview(view)
        }
        
        [brandLabel, modelLabel, hStackView].forEach { view in
            vStackView.addArrangedSubview(view)
        }
    }
    
    func configureCell(model: Item) {
        
        if let firstRef = model.popularProduct?.refImage?.first {
            let urlRef = storage.reference(forURL: firstRef)
            self.imageView.sd_setImage(with: urlRef, placeholderImage: UIImage(named: "DefaultImage"))
        } else {
            imageView.image = UIImage(named: "DefaultImage")
        }
        brandLabel.text = model.popularProduct?.brand
        modelLabel.text = model.popularProduct?.model
        shopLabel.text = model.popularProduct?.shops?.first
        priceLabel.text = "\(model.popularProduct?.price ?? 0) BYN"
    }
}

// MARK: - Layout
private extension PopProductCell {
    func setupConstraints() {
        
        let topImageViewCnstr = imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        topImageViewCnstr.priority = UILayoutPriority(999)
        topImageViewCnstr.isActive = true
        
        let trailingImageViewCnstr = imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        trailingImageViewCnstr.isActive = true
        
        let leadingImageViewCnstr = imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        leadingImageViewCnstr.isActive = true
        
        let heightImageViewCnstr = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1)
        heightImageViewCnstr.isActive = true
        
        let topStackCnstr = vStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
        topStackCnstr.isActive = true

        let trailingStackCnstr = vStackView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        trailingStackCnstr.isActive = true

        let leadingStackCnstr = vStackView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        leadingStackCnstr.isActive = true
        
        let bottomLabelCnstr = vStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        bottomLabelCnstr.priority = UILayoutPriority(999)
        bottomLabelCnstr.isActive = true
    }
}
