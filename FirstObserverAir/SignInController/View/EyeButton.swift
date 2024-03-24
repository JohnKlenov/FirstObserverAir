//
//  EyeButton.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 24.02.24.
//

import UIKit

final class EyeButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupEyeButton()
    }
    
    ///эта аннотация имеет реальные последствия в коде: если разработчик попытается использовать метод или свойство, помеченное как unavailable, компилятор Swift выдаст ошибку. Это помогает предотвратить непреднамеренное использование методов или свойств, которые могут быть небезопасными или привести к непредсказуемому поведению.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupEyeButton() {
        setImage(UIImage(systemName: "eye.slash"), for: .normal)
            
        tintColor = R.Colors.label
        widthAnchor.constraint(equalToConstant: 40).isActive = true
        isEnabled = false
    }
    
    deinit {
        print("deinit EyeButton")
    }
}

