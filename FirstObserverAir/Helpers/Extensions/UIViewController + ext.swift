//
//  UIViewController + ext.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 11.12.23.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func showErrorAlert(message: String, state: StateDataSource, tryActionHandler: @escaping () -> Void, cancelActionHandler: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        let tryAction = UIAlertAction(title: "Try again", style: .default) { _ in
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
    
    func showSettingAlert(title: String, message: String?, url: URL?, cancelActionHandler: (() -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingAction = UIAlertAction(title: "Setting", style: .default) { (alert) in
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            cancelActionHandler?()
        }
        alertController.addAction(settingAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
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

// MARK: - SafariViewController -
extension UIViewController {
    func presentSafariViewController(withURL: String) {
       
        guard let url = URL(string: withURL) else { return }
        
        let vc = SFSafariViewController(url: url)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
