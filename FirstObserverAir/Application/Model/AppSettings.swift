//
//  AppSettings.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 28.11.23.
//

import Foundation

class AppSettings {
    private enum SettingsKey: String {
        case didShowAppPresentation
    }
    
    static var didShowAppPresentation: Bool {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKey.didShowAppPresentation.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SettingsKey.didShowAppPresentation.rawValue)
        }
    }
    
    static func removeSettingsKey() {
        UserDefaults.standard.removeObject(forKey: SettingsKey.didShowAppPresentation.rawValue)
    }
}
