//
//  MallImageCell.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 18.01.24.
//

//import UIKit
//import FirebaseStorage
//import FirebaseStorageUI
//
//class MallCell: UICollectionViewCell {
//
//    static var reuseID: String = "MallCell"
//    var storage: Storage!
//
//    let imageView: UIImageView = {
//        let image = UIImageView()
//        image.translatesAutoresizingMaskIntoConstraints = false
//        image.layer.cornerRadius = 10
//        image.clipsToBounds = true
//        image.contentMode = .scaleAspectFill
//        return image
//    }()
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(imageView)
//        setupConstraints()
//        storage = Storage.storage()
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        if let layers = imageView.layer.sublayers {
//            for layerGradient in layers {
//                layerGradient.removeFromSuperlayer()
//            }
//        }
//    }
//
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: topAnchor),
//                                     imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
//                                     imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
//                                     imageView.bottomAnchor.constraint(equalTo: bottomAnchor)])
//    }
//
//    private func addGradientOverlay(correntFrame: CGSize) {
//        let gradientLayer = CAGradientLayer()
//
//        gradientLayer.frame.size = correntFrame
//        let overlayColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
//        gradientLayer.colors = [overlayColor.cgColor, overlayColor.cgColor]
//        self.imageView.layer.addSublayer(gradientLayer)
//    }
//    func configureCell(model:ItemCell, currentFrame: CGSize) {
////        model.brands?.refImage
//        if let firstRef = model.mallImage {
//            let urlRef = storage.reference(forURL: firstRef)
//
//            self.imageView.sd_setImage(with: urlRef, placeholderImage: UIImage(named: "DefaultImage"))
//        } else {
//            imageView.image = UIImage(named: "DefaultImage")
//        }
//        addGradientOverlay(correntFrame: currentFrame)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//}

