//
//  HeaderPopProductSection.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 18.12.23.
//

import UIKit

final class HeaderTitleSection: UICollectionReusableView {
    
    static let headerIdentifier = "HeaderTitle"
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .blue
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}


// MARK: - Setting Views
private extension HeaderTitleSection {
    func setupView() {
        addSubview(label)
        setupConstraints()
        backgroundColor = R.Colors.systemBackground
    }
}

// MARK: - Setting
extension HeaderTitleSection {
    func configureCell(title: String) {
        label.text = title
    }
}

// MARK: - Layout
private extension HeaderTitleSection {
    func setupConstraints() {
        NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: topAnchor, constant: 5), label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5), label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5), label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)])
    }
}
