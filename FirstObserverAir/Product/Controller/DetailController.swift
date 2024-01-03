//
//  DetailController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 2.01.24.
//

import UIKit

class DetailViewController: UIViewController {
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 8
        return view
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .redraw
        image.image = UIImage(named: "GalleriaMinsk")
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        return image
    }()
    
    let titleNameMallLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = R.Colors.systemPurple
        label.text = "Mall"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    let nameMallLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = R.Colors.label
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    let titleAddressMallLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = R.Colors.systemPurple
        label.text = "Address"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    let addressMallLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = R.Colors.label
        label.text = "LeninaStreet 55"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    let titleMetropolitanMallLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = R.Colors.systemPurple
        label.text = "Metropolitan station"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    let metropolitanMallLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = R.Colors.label
        label.text = "Kupalouskaya station"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    let stackViewNameMall: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    let stackViewAddressMall: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    let stackViewMetropolitanMall: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    let stackViewForStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 5
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.Colors.systemBackground
        setupStackView()
        setupContainerView()
        setupCnstrIntoContainerView()
        view.addSubview(containerView)
        setupCnstrOutsideContainerView()
//        view.addSubview(nameMallLabel)
//        nameMallLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        nameMallLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupContainerView() {
        containerView.addSubview(imageView)
        containerView.addSubview(stackViewForStackView)
    }
    
    private func setupStackView() {
        
        stackViewNameMall.addArrangedSubview(titleNameMallLabel)
        stackViewNameMall.addArrangedSubview(nameMallLabel)
        
        stackViewAddressMall.addArrangedSubview(titleAddressMallLabel)
        stackViewAddressMall.addArrangedSubview(addressMallLabel)
        
        stackViewMetropolitanMall.addArrangedSubview(titleMetropolitanMallLabel)
        stackViewMetropolitanMall.addArrangedSubview(metropolitanMallLabel)
        
        stackViewForStackView.addArrangedSubview(stackViewNameMall)
        stackViewForStackView.addArrangedSubview(stackViewAddressMall)
        stackViewForStackView.addArrangedSubview(stackViewMetropolitanMall)
    }
    
    private func setupCnstrIntoContainerView() {
        
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.6).isActive = true
        imageView.bottomAnchor.constraint(equalTo: stackViewForStackView.topAnchor, constant: -10).isActive = true
        stackViewForStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        stackViewForStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        stackViewForStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
    }
    
    private func setupCnstrOutsideContainerView() {
        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
//        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    }
    
    func configureViews(model: Shop) {
        
    }
}
