//
//  FooterCollectionView.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 2.01.24.
//

//import UIKit
//
//protocol FooterViewDelegate: AnyObject {
//    func currentPage(index: Int)
//}
//
//final class FooterViewCollectionView: UICollectionReusableView {
//    static let footerIdentifier = "FooterView"
//    private var pageControl: UIPageControl = {
//        let control = UIPageControl()
//        control.currentPage = 0
//        control.translatesAutoresizingMaskIntoConstraints = false
//        control.isUserInteractionEnabled = false
//        control.currentPageIndicatorTintColor = R.Colors.label
//        control.pageIndicatorTintColor = R.Colors.systemGray
//        return control
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        print("init FooterViewCollectionView")
//        setupView()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func configure(with numberOfPages: Int) {
//        pageControl.numberOfPages = numberOfPages
//    }
//
//    deinit {
//        print("deinit FooterViewCollectionView")
//    }
//}
//
//// MARK: - Setting Views
//private extension FooterViewCollectionView {
//    func setupView() {
//        backgroundColor = R.Colors.systemBackground
//        addSubview(pageControl)
//        setupConstraints()
//    }
//}
//
//// MARK: - Layout
//private extension FooterViewCollectionView {
//    func setupConstraints() {
//        NSLayoutConstraint.activate([
//            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
//            pageControl.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
//    }
//}
//
//// MARK: - FooterViewDelegate
//extension FooterViewCollectionView: FooterViewDelegate {
//    func currentPage(index: Int) {
//        pageControl.currentPage = index
//    }
//
//}
