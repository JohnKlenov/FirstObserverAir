//
//  NavigationMallCell.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 28.01.24.
//

import UIKit

final class NavigationMallCell: UICollectionViewCell {
    
    static var reuseID: String = "NavigationMallCell"
    
    private let compositeNavigationStck: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        /// .fillProportionally
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("deinit NavigationMallCell")
    }
}

// MARK: - Setting Views
private extension NavigationMallCell {
    func setupView() {
        contentView.backgroundColor = .clear
        contentView.addSubview(compositeNavigationStck)
        setupConstraints()
    }
}

// MARK: - Setting
extension NavigationMallCell {
    
    private func createButton(withTitle title: String, textColor: UIColor, fontSize: CGFloat, action: UIAction, image: UIImage.SymbolConfiguration?) -> UIButton {
        var configuration = UIButton.Configuration.gray()
        configuration.titleAlignment = .center
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = R.Colors.systemPurple
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 8.0
        configuration.preferredSymbolConfigurationForImage = image
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: fontSize)
        container.foregroundColor = textColor
        let attributedTitle = AttributedString(title, attributes: container)
        
        configuration.attributedTitle = attributedTitle
        
        let button = UIButton(configuration: configuration, primaryAction: action)
        button.tintColor = R.Colors.label
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    func configureCell(webAction:UIAction?, floorPlanAction:UIAction?) {
        
        //        // Очистка стека перед добавлением новых кнопок
        compositeNavigationStck.arrangedSubviews.forEach {
            compositeNavigationStck.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        var buttons = [UIButton]()
        
        if let webAction = webAction {
            let webPageForMallBtn = createButton(withTitle: R.Strings.OtherControllers.Mall.webPageForMallBtn, textColor: R.Colors.label, fontSize: 15, action: webAction, image: UIImage.SymbolConfiguration(scale: .large))
            buttons.append(webPageForMallBtn)
        }
        
        if let floorPlan = floorPlanAction {
            let floorPlanBtn = createButton(withTitle: R.Strings.OtherControllers.Mall.floorPlanBtn, textColor: R.Colors.label, fontSize: 15, action: floorPlan, image: UIImage.SymbolConfiguration(scale: .large))
            buttons.append(floorPlanBtn)
        }
        
        buttons.forEach { compositeNavigationStck.addArrangedSubview($0) }
    }
}

// MARK: - Layout
private extension NavigationMallCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            compositeNavigationStck.topAnchor.constraint(equalTo: contentView.topAnchor),
            compositeNavigationStck.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            compositeNavigationStck.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            compositeNavigationStck.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}



//        contentView.addSubview(compositeNavigationStck)
        
//        NSLayoutConstraint.activate([
//            compositeNavigationStck.topAnchor.constraint(equalTo: contentView.topAnchor),
//            compositeNavigationStck.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            compositeNavigationStck.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            compositeNavigationStck.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//        ])

//    func createButton(withTitle title: String, textColor: UIColor, fontSize: CGFloat, action: UIAction, image: UIImage.SymbolConfiguration?) -> UIButton {
//        var configuration = UIButton.Configuration.gray()
//        configuration.titleAlignment = .center
//        configuration.buttonSize = .large
//        configuration.baseBackgroundColor = R.Colors.systemPurple
//        configuration.imagePlacement = .trailing
//        configuration.imagePadding = 8.0
//        configuration.preferredSymbolConfigurationForImage = image
//        var container = AttributeContainer()
//        container.font = UIFont.boldSystemFont(ofSize: fontSize)
//        container.foregroundColor = textColor
//        let attributedTitle = AttributedString(title, attributes: container)
//
//        configuration.attributedTitle = attributedTitle
//
//        let button = UIButton(configuration: configuration, primaryAction: action)
//        button.tintColor = R.Colors.label
//        button.translatesAutoresizingMaskIntoConstraints = false
//
//        return button
//    }
//
//    func configureCell(webAction:UIAction?, floorPlanAction:UIAction?) {
//
//        //        // Очистка стека перед добавлением новых кнопок
//        compositeNavigationStck.arrangedSubviews.forEach {
//            compositeNavigationStck.removeArrangedSubview($0)
//            $0.removeFromSuperview()
//        }
//
//        var buttons = [UIButton]()
//
//        if let webAction = webAction {
//            let webPageForMallBtn = createButton(withTitle: R.Strings.OtherControllers.Mall.webPageForMallBtn, textColor: R.Colors.label, fontSize: 15, action: webAction, image: UIImage.SymbolConfiguration(scale: .large))
//            buttons.append(webPageForMallBtn)
//        }
//
//        if let floorPlan = floorPlanAction {
//            let floorPlanBtn = createButton(withTitle: R.Strings.OtherControllers.Mall.floorPlanBtn, textColor: R.Colors.label, fontSize: 15, action: floorPlan, image: UIImage.SymbolConfiguration(scale: .large))
//            buttons.append(floorPlanBtn)
//        }
//
//        buttons.forEach { compositeNavigationStck.addArrangedSubview($0) }
//    }
