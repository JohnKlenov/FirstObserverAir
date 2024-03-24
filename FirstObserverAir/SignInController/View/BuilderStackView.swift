//
//  BuilderStackView.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 25.02.24.
//

import UIKit

class BuilderStackView {
    
    static func build(title: String, textFieldPlaceholder: String, textContentType: UITextContentType, isSecureTextEntry:Bool, eyeButton: UIButton?, actionForTextField: UIAction, delegate: UITextFieldDelegate) -> (UIStackView, AuthTextField, UIView, UILabel) {
        
        let label = UILabel()
        label.text = title
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = R.Colors.label
        label.translatesAutoresizingMaskIntoConstraints = false

        let textField = AuthTextField(placeholder: textFieldPlaceholder)
        textField.textContentType = textContentType
        textField.isSecureTextEntry = isSecureTextEntry
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = delegate
        textField.addAction(actionForTextField, for: .editingChanged)
        if let eyeButton = eyeButton {
            textField.rightView = eyeButton
            textField.rightViewMode = .always
        }

        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.backgroundColor = R.Colors.separator
        
        let warningLabel = UILabel()
        warningLabel.text = ""
        warningLabel.numberOfLines = 0
        warningLabel.textColor = R.Colors.systemRed

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(separatorView)
        stackView.addArrangedSubview(warningLabel)

        return (stackView, textField, separatorView, warningLabel)
    }
    
    deinit {
        print("deinit BuilderStackView")
    }
}
