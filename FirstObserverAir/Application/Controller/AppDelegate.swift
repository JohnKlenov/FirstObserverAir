//
//  AppDelegate.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 3.11.23.
//

import UIKit
import FirebaseCore
import FirebaseStorageUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NetworkMonitor.shared.startMonitoring()
        FirebaseApp.configure()
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        /// удаляем весь ImageCache
//        SDImageCache.shared.clearMemory()
//        SDImageCache.shared.clearDisk(onCompletion: nil)
    }
    
    /// разрешить только портретную ориентацию на всех экранах
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }

}

