//
//  MallTableViewCell.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 2.01.24.
//

import UIKit
import FirebaseStorageUI

final class MallTableViewCell: UITableViewCell {
    
    static var reuseID: String = "MallTableViewCell"
    
    private let imageViewMall: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 5
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let nameMallLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.textColor = R.Colors.label
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
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
        //        imageView.sd_cancelCurrentImageLoad()
        //        imageView.image = nil
    }
    
    func configureCell(refImage:String, nameMall:String?) {
        nameMallLabel.text = nameMall
        let refStorage = Storage.storage().reference(forURL: refImage)
        imageViewMall.sd_setImage(with: refStorage, placeholderImage: UIImage(named: "DefaultImage"))
    }
}

// MARK: - Setting Views
private extension MallTableViewCell {
    func setupView() {
        backgroundColor = .clear
        contentView.addSubview(imageViewMall)
        contentView.addSubview(nameMallLabel)
        setupConstraints()
    }
}

// MARK: - Layout
private extension MallTableViewCell {
    func setupConstraints() {
        imageViewMall.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        imageViewMall.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        imageViewMall.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        imageViewMall.widthAnchor.constraint(equalTo: imageViewMall.heightAnchor, multiplier: 1).isActive = true
        
        nameMallLabel.leadingAnchor.constraint(equalTo: imageViewMall.trailingAnchor, constant: 20).isActive = true
        nameMallLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        nameMallLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
