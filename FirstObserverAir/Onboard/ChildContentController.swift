//
//  ChildContentController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 27.11.23.
//

import UIKit

class ChildContentViewController: UIViewController {
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        label.backgroundColor = .clear
        label.textColor = R.Colors.label
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
         super.viewDidLoad()
        view.backgroundColor = R.Colors.systemBackground
        view.addSubview(messageLabel)
        NSLayoutConstraint.activate([messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30), messageLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150)])
        
    }
    
    deinit {
        print("deinit ChildContentViewController")
    }
}
