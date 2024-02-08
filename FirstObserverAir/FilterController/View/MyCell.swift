//
//  MyCell.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 8.02.24.
//

import UIKit

class MyCell: UICollectionViewCell {

    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Добавление метки на ячейку и установка ограничений для ее размера
        contentView.backgroundColor = UIColor.secondarySystemBackground
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 0),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
//        contentView.layer.borderWidth = 1
//        contentView.layer.borderColor = UIColor.label.cgColor
        contentView.layer.cornerRadius = 5
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
