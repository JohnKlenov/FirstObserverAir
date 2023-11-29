//
//  ActivityContainerView.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 29.11.23.
//

import UIKit

final class ActivityContainerView: UIView {
    
    private var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.color = R.Colors.systemPurple
        loader.hidesWhenStopped = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    var isAnimating: Bool {
        return loader.isAnimating
    }
    
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
private extension ActivityContainerView {
    
    func setupView() {
        backgroundColor = R.Colors.opaqueSeparator
        addSubviews()
        setupConstraints()
    }
}

// MARK: - Setting
extension ActivityContainerView {
   private func addSubviews() {
        addSubview(loader)
    }
    func startAnimating() {
        loader.startAnimating()
    }
    func stopAnimating() {
        loader.stopAnimating()
    }
}

// MARK: - Layout
private extension ActivityContainerView {
    func setupConstraints() {
        NSLayoutConstraint.activate([loader.heightAnchor.constraint(equalToConstant: 50), loader.widthAnchor.constraint(equalToConstant: 50), loader.centerXAnchor.constraint(equalTo: centerXAnchor), loader.centerYAnchor.constraint(equalTo: centerYAnchor)])
    }
}
