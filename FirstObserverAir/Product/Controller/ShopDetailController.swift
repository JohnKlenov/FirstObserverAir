//
//  DetailController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 2.01.24.
//

import UIKit
import FirebaseStorageUI

final class ShopDetailController: UIViewController {
    
    
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
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        return image
    }()

    let imageIconPhone: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = UIImage(systemName: "phone.fill")
        image.clipsToBounds = true
        image.tintColor = R.Colors.systemPurple
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
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
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
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
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
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
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
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = R.Colors.referenceColor
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        let attributedString = NSMutableAttributedString(string: "No phone number")
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        return label
    }()

    let stackMall: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 3
        return stack
    }()

    let stackShop: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 3
        return stack
    }()

    let stackFloor: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 3
        return stack
    }()

    let stackTelefon: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 3
        return stack
    }()

    let stackIconAndNumberTelefon: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 15
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
        setupView()
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

// MARK: - Selectors
private extension ShopDetailController {
    @objc func dialPhoneNumber(sender:UITapGestureRecognizer) {
        if let phoneNumber = telefonLabel.text, let url = URL(string: "tel://\(phoneNumber.replacingOccurrences(of: " ", with: ""))"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - Setting Views
private extension ShopDetailController {
    func setupView() {
        view.backgroundColor = R.Colors.systemBackground
        setupTapGestureRecognizer()
        setupScrollView()
        setupStackView()
        setupContainerView()
        setupConstraints()
    }
}

// MARK: - Setting
extension ShopDetailController {
    func setupScrollView() {
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

    func setupContainerView() {
        containerView.addSubview(imageShop)
        containerView.addSubview(compositeStackView)
    }

    func setupStackView() {
        stackMall.addArrangedSubview(titleMallLabel)
        stackMall.addArrangedSubview(nameMallLabel)

        stackShop.addArrangedSubview(titleShopLabel)
        stackShop.addArrangedSubview(nameShopLabel)

        stackFloor.addArrangedSubview(titleFloorLabel)
        stackFloor.addArrangedSubview(floorLabel)

        stackIconAndNumberTelefon.addArrangedSubview(imageIconPhone)
        stackIconAndNumberTelefon.addArrangedSubview(telefonLabel)

        stackTelefon.addArrangedSubview(titleTelefonLabel)
        stackTelefon.addArrangedSubview(stackIconAndNumberTelefon)

        compositeStackView.addArrangedSubview(stackMall)
        compositeStackView.addArrangedSubview(stackShop)
        compositeStackView.addArrangedSubview(stackFloor)
        compositeStackView.addArrangedSubview(stackTelefon)
    }

    func setupTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dialPhoneNumber))
        telefonLabel.addGestureRecognizer(tap)
    }
}

// MARK: - Layout
private extension ShopDetailController {
    func setupConstraints() {
        imageShop.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        imageShop.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        imageShop.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        imageShop.heightAnchor.constraint(equalTo: imageShop.widthAnchor, multiplier: 0.6).isActive = true
        imageShop.bottomAnchor.constraint(equalTo: compositeStackView.topAnchor, constant: -10).isActive = true
        compositeStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        compositeStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        compositeStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
    }
}
