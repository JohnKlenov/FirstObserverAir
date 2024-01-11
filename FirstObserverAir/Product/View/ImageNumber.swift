//
//  ImageNumber.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 2.01.24.
//

import UIKit

final class NumberPagesView: UIView {
    
    private let numberOfPagesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = R.Colors.labelWhite
        label.backgroundColor = .clear
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(currentPage: Int, count: Int) {
        numberOfPagesLabel.text = "\(currentPage)/\(count)"
        numberOfPagesLabel.sizeToFit()
    }
    
    deinit {
        print("deinit NumberPagesView")
    }
}

// MARK: - Setting Views
private extension NumberPagesView {
    func setupView() {
        backgroundColor = R.Colors.systemGray
        addSubview(numberOfPagesLabel)
        setupConstraints()
    }
}

// MARK: - Layout
private extension NumberPagesView {
    func setupConstraints() {
        numberOfPagesLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        numberOfPagesLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        numberOfPagesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        numberOfPagesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
    }
}
