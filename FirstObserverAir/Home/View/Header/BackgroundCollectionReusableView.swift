//
//  BackgroundCollectionReusableView.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 18.12.23.
//

import UIKit

// используется для создания пользовательского фона для секций в вашем UICollectionView.
final class BackgroundViewCollectionReusableView: UICollectionReusableView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

// MARK: - Setting Views
private extension BackgroundViewCollectionReusableView {
    func setupView() {
        backgroundColor = .clear
        layer.cornerRadius = 12
    }
}
