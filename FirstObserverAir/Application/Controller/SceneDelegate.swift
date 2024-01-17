//
//  SceneDelegate.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 3.11.23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var isOffLocationService = false
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        rootLaunchScreenController()
        window?.makeKeyAndVisible()
        
//        AppSettings.removeSettingsKey()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if AppSettings.didShowAppPresentation {
                self.rootTabBarController()
            } else {
                self.rootPresentViewController()
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        setupLocationManager()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

// MARK: - PresentationDelegate
extension SceneDelegate: PresentationDelegate {
    func didFinishPresentation() {
        AppSettings.didShowAppPresentation = true
        rootTabBarController()
    }
}

// MARK: - Setting rootViewController
private extension SceneDelegate {
    
    func rootTabBarController() {
        let tabBarController = TabBarController()
        window?.rootViewController = tabBarController
    }
    func rootPresentViewController() {
        let childVC = ChildPageViewController()
        let presentController = PresentViewController(childVC: childVC)
        presentController.presentDelegate = self
        window?.rootViewController = presentController
    }
    
    func rootLaunchScreenController() {
        let launchScreen = LaunchScreenController()
        window?.rootViewController = launchScreen
    }
}

// MARK: - Seeting CLLocationManager
private extension SceneDelegate {
    func setupLocationManager() {
        // Попытка получить MapController
        if let tabBarController = window?.rootViewController as? UITabBarController,
           let navigationController = tabBarController.selectedViewController as? UINavigationController,
           let mapController = navigationController.presentedViewController as? MapController, isOffLocationService == true {
            mapController.setupLocationManager()
            mapController.checkLocationEnabled()
            isOffLocationService = false
        }
    }
}


