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

class CartView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        ?.withRenderingMode(.alwaysTemplate)
        if let image = UIImage(systemName: R.Strings.TabBarController.Cart.CartView.imageSystemNameCart) {
            let tintableImage = image.withRenderingMode(.alwaysTemplate)
            imageView.image = tintableImage
        }
//        image.image = UIImage(named: R.Strings.TabBarController.Cart.CartView.imageSystemNameCart)
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
    
    private let stackViewForLabel: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 2
        return stack
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
    
    private let stackViewForButton: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 5
        return stack
    }()
    
    weak var delegate: CartViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.cornerRadius = 10
        configureStackView()
        addSubview(imageView)
        addSubview(stackViewForLabel)
        addSubview(stackViewForButton)
        setupConstraints()
    }
    
    private func configureStackView() {
        let arrayLabel = [titleLabel, subtitleLabel]
        arrayLabel.forEach { view in
            stackViewForLabel.addArrangedSubview(view)
        }
        
        let arrayButton = [catalogButton, signInSignUpButton]
        arrayButton.forEach { view in
            stackViewForButton.addArrangedSubview(view)
        }
    }
    
    private func setupConstraints() {
        let topImageViewCnstr = imageView.topAnchor.constraint(equalTo: topAnchor, constant: 40)
        topImageViewCnstr.isActive = true
        let centerYImageViewCnstr = imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        centerYImageViewCnstr.isActive = true
        let widthImageViewCnstr = imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/5)
        widthImageViewCnstr.isActive = true
        let heightImageViewCnstr = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        heightImageViewCnstr.isActive = true
        let topStackForLabelCnstr = stackViewForLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0)
        topStackForLabelCnstr.isActive = true
        let trailingStackForLabelCnstr = stackViewForLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        trailingStackForLabelCnstr.isActive = true
        let leadingStackForLabelCnstr = stackViewForLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        leadingStackForLabelCnstr.isActive = true
        let topStackForButtonCnstr = stackViewForButton.topAnchor.constraint(equalTo: stackViewForLabel.bottomAnchor, constant: 20)
        topStackForButtonCnstr.isActive = true
        let trailingStackForButtonCnstr = stackViewForButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        trailingStackForButtonCnstr.isActive = true
        let leadingStackForButtonCnstr = stackViewForButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30)
        leadingStackForButtonCnstr.isActive = true
        let bottomStackForButtonCnstr = stackViewForButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        bottomStackForButtonCnstr.isActive = true
    }

    
    @objc func catalogButtonPressed(_ sender: UIButton) {
        delegate?.didTapCatalogButton()
    }
    
    @objc func logInButtonPressed(_ sender: UIButton) {
        delegate?.didTaplogInButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
