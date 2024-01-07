//
//  DetailController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 2.01.24.
//

import UIKit
import FirebaseStorageUI

class ShopDetailController: UIViewController {
    
    var storage = Storage.storage()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        return view
    }()
    
    let imageShop: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .redraw
        image.image = UIImage(named: "GalleriaMinsk")
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        return image
    }()
    
    let titleMallLabel: UILabel = {
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
    
    let titleShopLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = R.Colors.systemPurple
        label.text = "Shop"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    let nameShopLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = R.Colors.label
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    let titleFloorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = R.Colors.systemPurple
        label.text = "Floor"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    let floorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = R.Colors.label
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    let titleTelefonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = R.Colors.systemPurple
        label.text = "Telefon"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    let telefonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = R.Colors.label
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    let stackMall: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    let stackShop: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    let stackFloor: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    let stackTelefon: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    let compositeStackView: UIStackView = {
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
        setupScrollView()
        setupStackView()
        setupContainerView()
        setupCnstrIntoContainerView()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    private func setupContainerView() {
        containerView.addSubview(imageShop)
        containerView.addSubview(compositeStackView)
    }
    
    private func setupStackView() {
        stackMall.addArrangedSubview(titleMallLabel)
        stackMall.addArrangedSubview(nameMallLabel)
        
        stackShop.addArrangedSubview(titleShopLabel)
        stackShop.addArrangedSubview(nameShopLabel)
        
        stackFloor.addArrangedSubview(titleFloorLabel)
        stackFloor.addArrangedSubview(floorLabel)
        
        stackTelefon.addArrangedSubview(titleTelefonLabel)
        stackTelefon.addArrangedSubview(telefonLabel)
        
        compositeStackView.addArrangedSubview(stackMall)
        compositeStackView.addArrangedSubview(stackShop)
        compositeStackView.addArrangedSubview(stackFloor)
        compositeStackView.addArrangedSubview(stackTelefon)
    }
    
    private func setupCnstrIntoContainerView() {
        
        imageShop.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        imageShop.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        imageShop.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        imageShop.heightAnchor.constraint(equalTo: imageShop.widthAnchor, multiplier: 0.6).isActive = true
        imageShop.bottomAnchor.constraint(equalTo: compositeStackView.topAnchor, constant: -10).isActive = true
        compositeStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        compositeStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        compositeStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
    }
    
    func configureViews(model: Shop?) {
        let refStorage = storage.reference(forURL: model?.refImage ?? "")
        imageShop.sd_setImage(with: refStorage, placeholderImage: UIImage(named: "DefaultImage"))
        
        nameMallLabel.text = model?.mall
        nameShopLabel.text = model?.name
        floorLabel.text = model?.floor
        telefonLabel.text = model?.telefon
    }
}


//"lwejfiqwjeflqjwef;lkqjweflkjqwekl222222222224444444499999999999999fjqwlekfjlwkejflkqwjeflkqwjef;lkqwjefl;kjqwelfkj3333qwe;lfkjqw;lekfjqw;lkejfl;qkwjefl;kqwjef;lkqjwefl;kjqwelkfjqw;lkejf;qlwkefj222222222224444444499999999999999222222222224444444499999999999999222222222224444444499999999999999lwejfiqwjeflqjwef;lkqjweflkjqwekl222222222224444444499999999999999fjqwlekfjlwkejflkqwjeflkqwjef;lkqwjefl;kjqwelfkj3333qwe;lfkjqw;lekfjqw;lkejfl;qkwjefl;kqwjef;lkqjwefl;kjqwelkfjqw;lkejf;qlwkefj222222222224444444499999999999999222222222224444444499999999999999222222222224444444499999999999999"
