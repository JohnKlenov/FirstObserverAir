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


// MARK: - FilterController
///функция configureNavigationBar, настраивает внешний вид панели навигации.
///Установку цвета фона на backgoundColor.
///Установку цвета текста большого заголовка и обычного заголовка на largeTitleColor.
///Удаление тени под панелью навигации.
///Применение этих настроек к стандартному, компактному и scrollEdge внешнему виду панели навигации.
///Установку предпочтения больших заголовков в соответствии с параметром preferredLargeTitle.
///Установку свойства isTranslucent панели навигации в false, чтобы сделать панель навигации непрозрачной.
///Установку цвета элементов управления панели навигации (например, кнопок) на tintColor.
///Установку заголовка панели навигации на title.
extension UIViewController {

    /// configure navigationBar and combines status bar with navigationBar
    func configureNavigationBar(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
    if #available(iOS 13.0, *) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
        navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
        navBarAppearance.backgroundColor = backgoundColor
        navBarAppearance.shadowColor = .clear

        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

        navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = tintColor
        navigationItem.title = title

    } else {
        // Fallback on earlier versions
        navigationController?.navigationBar.barTintColor = backgoundColor
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.layer.shadowColor = nil
        navigationItem.title = title
    }
}}

// а что если несколько VC подписанных будут в памяти какое будет поведение?

// MARK: - UIAdaptivePresentationControllerDelegate
extension UIViewController: UIAdaptivePresentationControllerDelegate {
    ///В iOS 13 и более новых версиях, методы viewWillDisappear(_:) и viewWillAppear(_:) действительно не вызываются автоматически при появлении или исчезновении модального представления. Ваш код с UIAdaptivePresentationControllerDelegate обходит это ограничение, позволяя вам выполнить необходимую логику при закрытии модального представления.
    
    ///вызывается, когда контроллер презентации закрывается.
    ///Внутри этого метода, если версия iOS равна или больше 13, вызываются методы viewWillDisappear(_:) и viewWillAppear(_:). Это может быть полезно, если вы хотите выполнить определенные действия, когда представление исчезает или появляется, например, обновить данные или изменить состояние интерфейса.
    ///Однако, стоит отметить, что обычно методы viewWillDisappear(_:) и viewWillAppear(_:) вызываются автоматически системой в определенные моменты жизненного цикла представления, и их не рекомендуется вызывать вручную. В данном случае, они вызываются вручную, чтобы имитировать поведение, которое было до iOS 13, когда эти методы вызывались автоматически при закрытии модального представления.
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if #available(iOS 13, *) {
            //Call viewWillAppear only in iOS 13
            ///в каком порядке указать в таком они и работают???
//            viewWillDisappear(true)
//            viewWillAppear(true)
        }
    }
}


