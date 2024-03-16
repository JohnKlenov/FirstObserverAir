//
//  CartView.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 13.02.24.
//

import UIKit

protocol CartViewDelegate: AnyObject {
    func didTaplogInButton()
    func didTapCatalogButton()
}

final class CartView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(systemName: R.Strings.TabBarController.Cart.CartView.imageSystemNameCart) {
            let tintableImage = image.withRenderingMode(.alwaysTemplate)
            imageView.image = tintableImage
        }
        imageView.tintColor = R.Colors.label
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.backgroundColor = .clear
        label.textColor = R.Colors.label
        label.text = R.Strings.TabBarController.Cart.CartView.titleLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.backgroundColor = .clear
        label.textColor = R.Colors.label
        label.text = R.Strings.TabBarController.Cart.CartView.subtitleLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let catalogButton: UIButton = {
        
        var configuration = UIButton.Configuration.gray()
       
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 17)
        container.foregroundColor = R.Colors.label
        
        configuration.attributedTitle = AttributedString(R.Strings.TabBarController.Cart.CartView.catalogButton, attributes: container)
        configuration.titleAlignment = .center
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = R.Colors.systemPurple

        var grayButton = UIButton(configuration: configuration)
        grayButton.translatesAutoresizingMaskIntoConstraints = false
        
        grayButton.addTarget(self, action: #selector(catalogButtonPressed(_:)), for: .touchUpInside)
        
        return grayButton
    }()
    
    let signInSignUpButton: UIButton = {
        
        var configuration = UIButton.Configuration.gray()
       
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 17)
        container.foregroundColor = R.Colors.systemBackground
        
        configuration.attributedTitle = AttributedString(R.Strings.TabBarController.Cart.CartView.logInButton, attributes: container)
        configuration.titleAlignment = .center
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = R.Colors.systemPurple

        var grayButton = UIButton(configuration: configuration)
        grayButton.translatesAutoresizingMaskIntoConstraints = false
        
        grayButton.addTarget(self, action: #selector(logInButtonPressed(_:)), for: .touchUpInside)
        
        return grayButton
    }()
    
    weak var delegate: CartViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init CartView")
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupFrameView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit CartView")
    }
}


// MARK: - Setting Views
private extension CartView {
    func setupView() {
        backgroundColor = .clear
        layer.cornerRadius = 10
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(catalogButton)
        addSubview(signInSignUpButton)
    }
}

// MARK: - frame-based layout
private extension CartView {
    func setupFrameView() {
        let imageViewSize = frame.width / 5
        imageView.frame = CGRect(x: (frame.width - imageViewSize) / 2, y: frame.height/3, width: imageViewSize, height: imageViewSize)
        
        let titleLabelY = imageView.frame.maxY
        titleLabel.frame = CGRect(x: 10, y: titleLabelY, width: frame.width - 20, height: titleLabel.frame.height)
        
        let subtitleLabelY = titleLabel.frame.maxY + 5
        subtitleLabel.frame = CGRect(x: 10, y: subtitleLabelY, width: frame.width - 20, height: subtitleLabel.frame.height)
        
        let catalogButtonY = subtitleLabel.frame.maxY + 20
        catalogButton.frame = CGRect(x: 30, y: catalogButtonY, width: frame.width - 60, height: catalogButton.frame.height)
        
        let signInSignUpButtonY = catalogButton.frame.maxY + 5
        signInSignUpButton.frame = CGRect(x: 30, y: signInSignUpButtonY, width: frame.width - 60, height: signInSignUpButton.frame.height)
    }
}

// MARK: - Selector
private extension CartView {
    @objc func catalogButtonPressed(_ sender: UIButton) {
        delegate?.didTapCatalogButton()
    }
    
    @objc func logInButtonPressed(_ sender: UIButton) {
        delegate?.didTaplogInButton()
    }
}
