//
//  HeaderMallSection.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 18.12.23.
//

import UIKit

protocol HeaderMallSectionDelegate: AnyObject {
    func didSelectSegmentControl(gender:String)
}

class HeaderMallSection: UICollectionReusableView {
        
    static let headerIdentifier = "HeaderMall"
    let defaults = UserDefaults.standard
    weak var delegate: HeaderMallSectionDelegate?
   
    let segmentedControl: UISegmentedControl = {
        let item = [R.Strings.TabBarController.Home.ViewsHome.segmentedControlWoman,R.Strings.TabBarController.Home.ViewsHome.segmentedControlMan]
        let segmentControl = UISegmentedControl(items: item)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.addTarget(nil, action: #selector(didTapSegmentedControl(_:)), for: .valueChanged)
        segmentControl.backgroundColor = R.Colors.systemFill
        return segmentControl
    }()
    
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
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(handleSwitchSegmentControlNotification), name: NSNotification.Name("SwitchSegmentControlNotification"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

// MARK: - Setting Views
private extension HeaderMallSection {
    func setupView() {
        backgroundColor = .clear
        addSubview(segmentedControl)
        addSubview(label)
        setupConstraints()
    }
}

// MARK: - Setting
extension HeaderMallSection {
    func configureCell(title: String, gender: String) {
//        let gender = defaults.string(forKey: "gender") ?? "Woman"
        segmentedControl.selectedSegmentIndex = gender == "Woman" ? 0 : 1
        label.text = title
    }
}

// MARK: - Layout
private extension HeaderMallSection {
    func setupConstraints() {
        NSLayoutConstraint.activate([segmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: 5), segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40), segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40), label.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 5), label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5), label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5), label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)])
    }
}

// MARK: - Selectors
private extension HeaderMallSection {
    
    @objc func handleSwitchSegmentControlNotification(_ notification: NSNotification) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            segmentedControl.selectedSegmentIndex = 1
        case 1:
            segmentedControl.selectedSegmentIndex = 0
        default:
            break
        }
    }

    
    @objc func didTapSegmentedControl(_ segmentControl: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
//            defaults.set("Woman", forKey: "gender")
            delegate?.didSelectSegmentControl(gender: "Woman")
            break
        case 1:
//            defaults.set("Man", forKey: "gender")
            delegate?.didSelectSegmentControl(gender: "Man")
            break
        default:
            break
        }
    }
}
