//
//  XMarkView.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 13.01.24.
//

import Foundation
import UIKit

class DeleteView: UIView {
    
    private let deleteImage: UIImageView = {
        let view = UIImageView(image: R.Images.FullScreenImageController.xmark?.withTintColor(.black, renderingMode: .alwaysOriginal))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkGray.withAlphaComponent(0.5)
        addSubview(deleteImage)
        setupConstraints()
    }
    
    private func setupConstraints() {
        deleteImage.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        deleteImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        deleteImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        deleteImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
