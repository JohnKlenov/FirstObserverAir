//
//  SettingScreenOrientation.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 17.01.24.
//

import UIKit

struct SettingScreenOrientation {

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    /// этот метод позволяет вам не только блокировать ориентацию экрана, но и немедленно поворачивать экран в желаемую ориентацию. Это может быть полезно, если вы хотите, чтобы ваше приложение отображалось в определенной ориентации в определенный момент времени.
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }

}
