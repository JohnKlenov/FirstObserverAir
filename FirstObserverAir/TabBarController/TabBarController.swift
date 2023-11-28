//
//  TabBarController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 26.11.23.
//

import UIKit

enum Tabs: Int, CaseIterable {
    case Home
    case Catalog
    case Mall
    case Cart
    case Profile
}

final class TabBarController: UITabBarController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }


}

// MARK: - Setting Views
private extension TabBarController {
    
    func setupView() {
        configureAppearance()
        addTabBarSeparator()
    }
}


// MARK: - Setting
private extension TabBarController {
   
    func switchTo(tab: Tabs) {
        selectedIndex = tab.rawValue
    }

    private func configureAppearance() {
        tabBar.tintColor = R.Colors.systemPurple
        tabBar.backgroundColor = R.Colors.systemBackground

        let controllers: [NavigationController] = Tabs.allCases.map { tab in
            let controller = NavigationController(rootViewController: getController(for: tab))
            controller.tabBarItem = UITabBarItem(title: R.Strings.TabBarItem.title(for: tab),
                                                 image: R.Images.TabBarItem.icon(for: tab),
                                                 tag: tab.rawValue)
            return controller
        }

        setViewControllers(controllers, animated: false)
    }

    private func getController(for tab: Tabs) -> UIViewController {
        switch tab {
        case .Home: return HomeController()
        case .Catalog: return CatalogController()
        case .Mall: return MallsController()
        case .Cart: return CartController()
        case .Profile: return ProfileController()
        }
    }
}


// MARK: - Layout
private extension TabBarController {
    
}


