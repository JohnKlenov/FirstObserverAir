//
//  ShopForMallCell.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 18.01.24.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI


class BrandCellMallVC: UICollectionViewCell {
    
    static var reuseID: String = "BrandCell"
    var storage: Storage!
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    let nameBrandLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = R.Colors.systemPurple
        label.backgroundColor = .clear
        return label
    }()
    
    let floorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "3 floor"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = R.Colors.secondaryLabel
        label.backgroundColor = .clear
        return label
    }()
    
    let stackViewForLabel: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 0
        return stack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStackView()
        addSubview(imageView)
        addSubview(stackViewForLabel)
        setupConstraints()
        storage = Storage.storage()
        backgroundColor = .clear
    }
    
    private func configureStackView() {

        let arrayViews = [nameBrandLabel, floorLabel]
        arrayViews.forEach { view in
            stackViewForLabel.addArrangedSubview(view)
            
        }
    }
    
    private func setupConstraints() {
        
        let topImageViewCnstr = imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10)
        topImageViewCnstr.priority = UILayoutPriority(999)
        topImageViewCnstr.isActive = true
        
        let trailingImageViewCnstr = imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        trailingImageViewCnstr.isActive = true
        
        let leadingImageViewCnstr = imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        leadingImageViewCnstr.isActive = true
        
        let heightImageViewCnstr = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1)
        heightImageViewCnstr.isActive = true
        
        let topStackCnstr = stackViewForLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5)
        topStackCnstr.isActive = true
        
        let trailingStackCnstr = stackViewForLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        trailingStackCnstr.isActive = true
        
        let leadingStackCnstr = stackViewForLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        leadingStackCnstr.isActive = true
        
        let bottomStackCnstr = stackViewForLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        bottomStackCnstr.priority = UILayoutPriority(999)
        bottomStackCnstr.isActive = true
    }
    
    func configureCell(model: Item) {
        
        if let firstRef = model.shop?.refImage {
            let urlRef = storage.reference(forURL: firstRef)
            
            self.imageView.sd_setImage(with: urlRef, placeholderImage: UIImage(named: "DefaultImage"))
        } else {
            imageView.image = UIImage(named: "DefaultImage")
        }
        nameBrandLabel.text = model.shop?.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
