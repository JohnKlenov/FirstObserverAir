//
//  FilterTabBar.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 8.02.24.
//

import UIKit

protocol CustomTabBarViewDelegate: AnyObject {
    func customTabBarViewDidTapButton(_ tabBarView: CustomTabBarView)
}

class CustomTabBarView: UIView {
    
    weak var delegate: CustomTabBarViewDelegate?
    
//    var countProducts:Int?
    let button: UIButton = {
        var configButton = UIButton.Configuration.gray()
        configButton.title = "Show products"
        configButton.baseForegroundColor = UIColor.systemOrange
//        configButton.baseForegroundColor = UIColor.label
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
        backgroundColor = UIColor.secondarySystemBackground
        setupButton()
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupButton()
    }

    private func setupButton() {
        addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            button.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            // Установим отступ до зоны жестов
            button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    func setCounterButton(count:Int) {
        button.configuration?.title = "Show products(\(count))"
        if count <= 0 {
            button.isEnabled = false
        } else {
            button.isEnabled = true
        }
    }
    
    @objc func didTapDoneButton() {
        delegate?.customTabBarViewDidTapButton(self)
//        print("didTapDoneButton")
    }
}
