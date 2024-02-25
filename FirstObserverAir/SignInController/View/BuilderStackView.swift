//
//  BuilderStackView.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 25.02.24.
//

import UIKit

class BuilderStackView {
    
    static func build(title: String, textFieldPlaceholder: String, textContentType: UITextContentType, eyeButton: UIButton?, actionForTextField: UIAction, delegate: UITextFieldDelegate) -> (UIStackView, AuthTextField, UIView) {
        
        let label = UILabel()
        label.text = title
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = R.Colors.label
        label.translatesAutoresizingMaskIntoConstraints = false

        let textField = AuthTextField(placeholder: textFieldPlaceholder)
        textField.textContentType = textContentType
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

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(separatorView)

        return (stackView, textField, separatorView)
    }
}
