//
//  UIViewController + ext.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 11.12.23.
//

import UIKit

extension UIViewController {
    
    func showErrorAlert(message: String, state: StateDataSource, tryActionHandler: @escaping () -> Void, cancelActionHandler: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        let tryAction = UIAlertAction(title: "Try agayn", style: .cancel) { _ in
            tryActionHandler()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            cancelActionHandler?()
        }
        switch state {
            
        case .firstDataUpdate:
            alert.addAction(tryAction)
        case .followingDataUpdate:
            alert.addAction(tryAction)
            alert.addAction(cancelAction)
        }
        self.present(alert, animated: true)
    }
    
    
    // MARK: NavigationController
    func setBackButtonWithoutTitle(_ title: String) {
        let item = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = item
    }
    
    
    // MARK: disable and enable controls
    func setViewUserInteraction(_ isEnabled: Bool) {
            view.isUserInteractionEnabled = isEnabled
        }

        func setNavigationBarUserInteraction(_ isEnabled: Bool) {
            navigationController?.navigationBar.isUserInteractionEnabled = isEnabled
        }

        func setTabBarUserInteraction(_ isEnabled: Bool) {
            tabBarController?.tabBar.isUserInteractionEnabled = isEnabled
        }

        func setUserInteraction(_ isEnabled: Bool) {
            setViewUserInteraction(isEnabled)
            setNavigationBarUserInteraction(isEnabled)
            setTabBarUserInteraction(isEnabled)
        }
}
