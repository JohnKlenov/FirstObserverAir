//
//  PageFooterMallView.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 18.01.24.
//

import UIKit

protocol PageFooterMallDelegate: AnyObject {
    func currentPage(index: Int)
}
class PagingSectionFooterView: UICollectionReusableView {
    static let footerIdentifier = "FooterMall"
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
        setupView()
        backgroundColor = .clear
    }
    func configure(with numberOfPages: Int) {
        pageControl.numberOfPages = numberOfPages
    }
    
    private func setupView() {
        addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
        }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}

extension PagingSectionFooterView: PageFooterMallDelegate {
    func currentPage(index: Int) {
        pageControl.currentPage = index
        print("PagingSectionDelegate")
    }
}

