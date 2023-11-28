//
//  LaunchScreenController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 28.11.23.
//

import UIKit

final class LaunchScreenController: UIViewController {

    private let observerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.backgroundColor = .clear
        label.textColor = R.Colors.label
        label.text = R.Strings.OtherControllers.LaunchScreen.nameBrand
        label.numberOfLines = 1
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Setting Views
private extension LaunchScreenController {
    
    func setupView() {
        view.backgroundColor = R.Colors.systemBackground
        addSubviews()
        setupConstraints()
    }
}

// MARK: - Setting
private extension LaunchScreenController {
    func addSubviews() {
        view.addSubview(observerLabel)
    }

}

// MARK: - Layout
private extension LaunchScreenController {
    
    func setupConstraints() {
        NSLayoutConstraint.activate([observerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor), observerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }
}
