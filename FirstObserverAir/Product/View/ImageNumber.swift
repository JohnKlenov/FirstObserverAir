//
//  ImageNumber.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 2.01.24.
//

import UIKit

class NumberPagesView: UIView {
    
    private let numberOfPagesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//        label.textColor = R.Colors.textColorWhite
        label.textColor = .white
        label.backgroundColor = .clear
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = R.Colors.backgroundLithGray
        backgroundColor = .systemGray
        addSubview(numberOfPagesLabel)
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        numberOfPagesLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        numberOfPagesLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        numberOfPagesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        numberOfPagesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        
    }
    func configureView(currentPage: Int, count: Int) {
        numberOfPagesLabel.text = "\(currentPage)/\(count)"
        numberOfPagesLabel.sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
