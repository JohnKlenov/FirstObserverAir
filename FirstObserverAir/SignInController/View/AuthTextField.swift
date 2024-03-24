//
//  AuthTextField.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 24.02.24.
//

import UIKit

final class AuthTextField: UITextField {
    
    var textPadding = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: -5,
            right: 0
        )
    
    init(placeholder:String) {
        super.init(frame: .zero)
        setupTextField(placeholder: placeholder)
    }
    
    // Init?(coder: NSCoder) - имеет отношение к storyboard.
    //    @available(*, unavailable) - Но так как у нас его нет мы сделаем пометку что бы компилятор его не использовал.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField(placeholder: String) {
        backgroundColor = .clear
        textColor = R.Colors.label
        
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : R.Colors.placeholderText])
        font = .systemFont(ofSize: 15, weight: .medium)
        borderStyle = .none
        heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    
    ///настроиваем положение текста внутри UITextField
    ///определяет область текста, когда текстовое поле не редактируется
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    /// определяет область текста во время редактирования.
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    deinit {
        print("deinit AuthTextField")
    }
}


