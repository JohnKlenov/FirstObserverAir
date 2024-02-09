//
//  FilterCell.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 7.02.24.
//

import UIKit

protocol FilterCellDelegate: AnyObject {
    func didDeleteCellFilter(_ filterCell: FilterCell)
}

class FilterCell: UICollectionViewCell {

    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let deleteButton: UIButton = {
        var configuration = UIButton.Configuration.gray()
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = .clear
        configuration.image = UIImage(systemName: "xmark")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        var grayButton = UIButton(configuration: configuration)
        grayButton.translatesAutoresizingMaskIntoConstraints = false
        grayButton.addTarget(self, action: #selector(didTapDeleteButton(_:)), for: .touchUpInside)
        
        return grayButton
    }()
    
    weak var delegate: FilterCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setting Views
private extension FilterCell {
    
    func setupView() {
        // Добавление метки на ячейку и установка ограничений для ее размера
        contentView.backgroundColor = UIColor.secondarySystemBackground
        contentView.addSubview(label)
        contentView.addSubview(deleteButton)
        contentView.layer.cornerRadius = 5
        setupConstraints()
    }
}

// MARK: - Setting
extension FilterCell {
    func configureCell(textLabel:String) {
        print("configureCell(textLabel:String) - \(textLabel)")
        label.text = textLabel
    }
}

// MARK: - Layout
private extension FilterCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 0),
            label.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: 0),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            deleteButton.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            deleteButton.heightAnchor.constraint(equalTo: label.heightAnchor),
            deleteButton.widthAnchor.constraint(equalTo: deleteButton.heightAnchor)
        ])
    }
}

// MARK: - Selector
private extension FilterCell {
    @objc func didTapDeleteButton(_ sender: UIButton) {
        delegate?.didDeleteCellFilter(self)
    }
}


