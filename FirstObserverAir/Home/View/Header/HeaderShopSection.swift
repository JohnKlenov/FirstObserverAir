//
//  HeaderShopSection.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 18.12.23.
//

import UIKit

protocol HeaderShopSectionDelegate: AnyObject {
    func didSelectAllShopButton()
}


class HeaderShopSection: UICollectionReusableView {
        
    static let headerIdentifier = "HeaderShop"
    let label:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.backgroundColor = .clear
        label.tintColor = R.Colors.label
        label.numberOfLines = 0
        return label
    }()
    
    let allShopButton: UIButton = {
        var configButton = UIButton.Configuration.gray()
        configButton.title = R.Strings.TabBarController.Home.ViewsHome.headerShopAllShopButton
        configButton.baseForegroundColor = R.Colors.systemPurple
        configButton.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incomig in

            var outgoing = incomig
            outgoing.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            return outgoing
        }
        configButton.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4)
        var button = UIButton(configuration: configButton)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(allShopHandler), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: HeaderShopSectionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

// MARK: - Setting Views
private extension HeaderShopSection {
    func setupView() {
        backgroundColor = .clear
        addSubview(label)
        addSubview(allShopButton)
        setupConstraints()
    }
}

// MARK: - Setting
extension HeaderShopSection {
    func configureCell(title: String) {
        label.text = title
    }
}

// MARK: - Layout
private extension HeaderShopSection {
    func setupConstraints() {
        NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: topAnchor, constant: 8), label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5), label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5), allShopButton.topAnchor.constraint(equalTo: topAnchor, constant: 8), allShopButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5), allShopButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)])
    }
}


// MARK: - Selectors
private extension HeaderShopSection {
    @objc func allShopHandler() {
        delegate?.didSelectAllShopButton()
    }
}
