//
//  CustomNavigationBar.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 20.01.24.

import UIKit

class NavigationHeader{
    
    var backAction: UIAction?
    var menuAction: UIAction?
    var closeAction: UIAction?
    var date: Date
    
    
    private lazy var navigationView: UIView = {
        $0.frame = CGRect(x: 30, y: 0, width: UIScreen.main.bounds.width - 60, height: 44)
        $0.backgroundColor = R.Colors.systemBackground
        $0.addSubview(dateStack)
        return $0
        
    }(UIView())
    
    lazy var dateLabel: UILabel = getHeaderLabel(text: date.formattDate(formatType: .onlyDate), size: 30, weight: .bold)
    lazy var yearLabel: UILabel = getHeaderLabel(text: date.formattDate(formatType: .onlyYear) + " год", size: 14, weight: .light)
    
    lazy var backButton: UIButton = getActionButton(origin: CGPoint(x: 0, y: 9), icon: UIImage(), action: backAction)
    
    lazy var closeButton: UIButton = getActionButton(origin: CGPoint(x: navigationView.frame.width - 30, y: 0), icon: UIImage(), action: closeAction)
    
    lazy var menuButton: UIButton = getActionButton(origin: CGPoint(x: navigationView.frame.width - 30, y: 9), icon: UIImage(), action: menuAction)
    
    
    lazy var dateStack: UIStackView = {
        $0.axis = .vertical
        $0.addArrangedSubview(dateLabel)
        $0.addArrangedSubview(yearLabel)
        return $0
    }(UIStackView(frame: CGRect(x: 45, y: 0, width: 200, height: 44)))
    
    
    init(backAction: UIAction? = nil, menuAction: UIAction? = nil, closeAction: UIAction? = nil, date: Date) {
        self.backAction = backAction
        self.menuAction = menuAction
        self.closeAction = closeAction
        self.date = date
    }
    
    
    func getNavigationHeader(type: NavigationHeaderType) -> UIView{
        switch type {
        case .back:
            navigationView.addSubview(backButton)
            navigationView.addSubview(menuButton)
        case .close:
            navigationView.addSubview(closeButton)
        }
        
        return navigationView
    }
    
    private func getActionButton(origin: CGPoint, icon: UIImage, action: UIAction?) -> UIButton{
        let btn = UIButton(primaryAction: action)
        btn.frame.size = CGSize(width: 25, height: 25)
        btn.frame.origin = origin
        btn.setBackgroundImage(icon, for: .normal)
        return btn
    }
    
    private func getHeaderLabel(text: String, size: CGFloat, weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: size, weight: weight)
        return label

    }
    
}

enum NavigationHeaderType {
    case back, close
}



//class DetailsView: UIViewController {
//
////    var presenter: DetailsViewPresenterProtocol!
//    private var menuViewHeight = UIApplication.topSafeArea + 50
//
//    lazy var topMenuView: UIView = {
//        $0.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: menuViewHeight)
//        $0.backgroundColor = R.Colors.systemBackground
//        return $0
//    }(UIView())
//
//    lazy var backAction = UIAction { [weak self] _ in
//        self?.navigationController?.popViewController(animated: true)
//    }
//
//    lazy var menuAction = UIAction { [weak self] _ in
//        print("menu open")
//    }
//
//    lazy var navigationHeader: NavigationHeader = {
//        NavigationHeader(backAction: backAction, menuAction: menuAction, date: presenter.item.date)
//    }()
//
//    override func viewDidLoad() {
//            super.viewDidLoad()
//        view.backgroundColor = R.Colors.systemBackground
//            view.addSubview(topMenuView)
//            setupPageHeader()
//        }
//
//        override func viewWillAppear(_ animated: Bool) {
//            navigationController?.navigationBar.prefersLargeTitles = false
//            navigationItem.setHidesBackButton(true, animated: true)
//            navigationController?.navigationBar.isHidden = true
//        }
//
//        private func setupPageHeader() {
//            let headerView = navigationHeader.getNavigationHeader(type: .back)
//            headerView.frame.origin.y = UIApplication.topSafeArea
//            view.addSubview(headerView)
//
//        }
//}
