//
//  FilterTabBar.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 8.02.24.
//

import UIKit

protocol FilterTabBarDelegate: AnyObject {
    func customTabBarViewDidTapButton(_ tabBarView: FilterTabBar)
}

final class FilterTabBar: UIView {
    
    weak var delegate: FilterTabBarDelegate?
    
    let button: UIButton = {
        var configButton = UIButton.Configuration.gray()
        configButton.title = "Show products"
        configButton.baseForegroundColor = UIColor.systemOrange
        configButton.buttonSize = .large
        configButton.baseBackgroundColor = UIColor.systemGray3
        configButton.titleAlignment = .leading
        configButton.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incomig in

            var outgoing = incomig
            outgoing.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            return outgoing
        }
        var button = UIButton(configuration: configButton)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit FilterTabBar")
    }
}

// MARK: - Setting Views
private extension FilterTabBar {
    
    func setupView() {
        backgroundColor = UIColor.secondarySystemBackground
        addSubview(button)
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
}

// MARK: - Setting
extension FilterTabBar {
    func setCounterButton(count:Int) {
        button.configuration?.title = "Show products(\(count))"
        if count <= 0 {
            button.isEnabled = false
        } else {
            button.isEnabled = true
        }
    }
}

// MARK: - Layout
private extension FilterTabBar {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            button.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            // Установим отступ до зоны жестов
            button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}

// MARK: - Selector
private extension FilterTabBar {
    @objc func didTapDoneButton() {
        delegate?.customTabBarViewDidTapButton(self)
    }
}


