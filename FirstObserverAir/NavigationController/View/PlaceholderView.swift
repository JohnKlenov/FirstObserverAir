//
//  PlaceholderView.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 29.11.23.
//

import UIKit

final class PlaceholderView: UIView {
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = R.Colors.label
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
}

// MARK: - Setting Views
private extension PlaceholderView {
    
    func setupView() {
        backgroundColor = R.Colors.systemBackground
        configureImageView()
        addSubviews()
        setupConstraints()
    }
}

// MARK: - Setting
private extension PlaceholderView {
    
    func configureImageView() {
        // есть несколько стилей прорисовок для символов системных иконок: .thin, .medium ..
        let symbolConfig = UIImage.SymbolConfiguration(weight: .ultraLight)
        let image = UIImage(systemName: "exclamationmark.triangle", withConfiguration: symbolConfig)
        let tintableImage = image?.withRenderingMode(.alwaysTemplate)
        imageView.image = tintableImage
    }
    
    func addSubviews() {
        addSubview(imageView)
    }
}

// MARK: - Layout
private extension PlaceholderView {
    func setupConstraints() {
        NSLayoutConstraint.activate([imageView.centerXAnchor.constraint(equalTo: centerXAnchor), imageView.centerYAnchor.constraint(equalTo: centerYAnchor), imageView.widthAnchor.constraint(equalTo: widthAnchor), imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)])
    }
}

