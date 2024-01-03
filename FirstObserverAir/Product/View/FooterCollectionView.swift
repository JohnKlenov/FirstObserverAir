//
//  FooterCollectionView.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 2.01.24.
//

import UIKit

protocol FooterViewDelegate: AnyObject {
    func currentPage(index: Int)
}
class FooterViewCollectionView: UICollectionReusableView {
    static let footerIdentifier = "FooterView"
    lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        control.isUserInteractionEnabled = false
        control.currentPageIndicatorTintColor = R.Colors.label
        control.pageIndicatorTintColor = R.Colors.systemGray
        return control
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = R.Colors.systemBackground
        setupView()
    }
    
    func configure(with numberOfPages: Int) {
            pageControl.numberOfPages = numberOfPages
        }
    
    private func setupView() {
//            backgroundColor = .clear
            
            addSubview(pageControl)
            
            NSLayoutConstraint.activate([
                pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
                pageControl.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
//        fatalError("init(coder:) has not been implemented")
    }
}

extension FooterViewCollectionView: FooterViewDelegate {
    func currentPage(index: Int) {
        pageControl.currentPage = index
    }
    
}
