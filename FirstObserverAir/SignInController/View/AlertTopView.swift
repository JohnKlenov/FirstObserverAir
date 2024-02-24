//
//  AlertTopView.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 24.02.24.
//

import UIKit

class AlertTopView: UIView {

    
    let labelWarning: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        label.textColor = R.Colors.label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init AlertTopView")
        self.addSubview(labelWarning)
        setConstraintLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setConstraintLabel() {
        NSLayoutConstraint.activate([labelWarning.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                     labelWarning.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                                     labelWarning.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     labelWarning.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)])
    }
    
    func setupAlertTopView(labelText: String, backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        labelWarning.text = labelText
    }
    
    deinit {
        print("deinit AlertTopView")
    }
    
}

