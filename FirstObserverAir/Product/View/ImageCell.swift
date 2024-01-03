//
//  ImageCell.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 2.01.24.
//

import UIKit
import FirebaseStorageUI

class ImageCell: UICollectionViewCell {
    
    static var reuseID: String = "ImageCell"
    var storage: Storage!
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        setupConstraints()
        storage = Storage.storage()
    }
    
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: topAnchor),
                                     imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     imageView.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
    
    
    func configureCell(refImage:String) {
        let refStorage = storage.reference(forURL: refImage)
        imageView.sd_setImage(with: refStorage, placeholderImage: UIImage(named: "DefaultImage"))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

