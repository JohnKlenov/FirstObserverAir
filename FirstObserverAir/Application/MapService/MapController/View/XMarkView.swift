//
//  XMarkView.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 13.01.24.
//

import UIKit

final class XMarkView: UIView {
    
    private let closeImage: UIImageView = {
        let view = UIImageView(image: R.Images.FullScreenImageController.xmark?.withTintColor(.black, renderingMode: .alwaysOriginal))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit XMarkView")
    }
}

// MARK: - Setting Views
private extension XMarkView {
    func setupView() {
        backgroundColor = .darkGray.withAlphaComponent(0.5)
        addSubview(closeImage)
        setupConstraints()
    }
}

// MARK: - Layout
private extension XMarkView {
    func setupConstraints() {
        closeImage.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        closeImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        closeImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        closeImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
    }
}
