//
//  HeaderCatalogSection.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 3.02.24.
//

import UIKit

protocol HeaderCatalogSectionDelegate: AnyObject {
    func didSelectSegmentControl(gender:String)
}

class HeaderCatalogSection: UICollectionReusableView {
        
    static let headerIdentifier = "HeaderCatalog"
    weak var delegate: HeaderCatalogSectionDelegate?
    
    let segmentedControl: UISegmentedControl = {
        let item = [R.Strings.TabBarController.Home.ViewsHome.segmentedControlWoman,R.Strings.TabBarController.Home.ViewsHome.segmentedControlMan]
        let segmentControl = UISegmentedControl(items: item)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.addTarget(nil, action: #selector(didTapSegmentedControl(_:)), for: .valueChanged)
        segmentControl.backgroundColor = R.Colors.systemFill
        return segmentControl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(handleSwitchSegmentControlNotification), name: NSNotification.Name("SwitchSegmentControlHeaderCatalogNotification"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

// MARK: - Setting Views
private extension HeaderCatalogSection {
    func setupView() {
        backgroundColor = .clear
        addSubview(segmentedControl)
        setupConstraints()
    }
}

// MARK: - Setting
extension HeaderCatalogSection {
    func configureCell(gender: String) {
        segmentedControl.selectedSegmentIndex = gender == "Woman" ? 0 : 1
    }
}

// MARK: - Layout
private extension HeaderCatalogSection {
    func setupConstraints() {
        NSLayoutConstraint.activate([segmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: 5), segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60), segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),  segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)])
    }
}

// MARK: - Selectors
private extension HeaderCatalogSection {
    
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
            delegate?.didSelectSegmentControl(gender: "Woman")
            break
        case 1:
            delegate?.didSelectSegmentControl(gender: "Man")
            break
        default:
            break
        }
    }
}

