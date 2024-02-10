//
//  HeaderFilter.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 8.02.24.
//

import UIKit

protocol HeaderFilterCollectionViewDelegate: AnyObject {
    func didSelectSegmentControl()
}

class HeaderFilterCollectionReusableView: UICollectionReusableView {
    
    static let headerIdentifier = "HeaderFilterVC"
    weak var delegate: HeaderFilterCollectionViewDelegate?

    let label:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.backgroundColor = .clear
//        label.tintColor = .black
        label.textColor = UIColor.label
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
//        addSubview(separatorView)
        setupConstraints()
        backgroundColor = .clear
    }
   
    static func referenceSize(width: CGFloat, title: String) -> CGSize {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 17)
            label.text = title
            let height = label.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
            return CGSize(width: width, height: height + 10)
        }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: topAnchor, constant: 5), label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5), label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10), label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)])
    }
    
    func configureCell(title: String) {
        label.text = title
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(label)
        setupConstraints()
        backgroundColor = .clear
//        fatalError("init(coder:) has not been implemented")
    }
}
