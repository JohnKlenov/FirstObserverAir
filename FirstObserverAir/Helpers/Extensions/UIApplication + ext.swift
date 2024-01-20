//
//  UIApplication + ext.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 20.01.24.

import UIKit

/// Это свойство возвращает верхний отступ безопасной области (safe area) первого окна текущей сцены приложения.
/// headerView.frame.origin.y = UIApplication.topSafeArea
extension UIApplication{
    static var topSafeArea: CGFloat {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene?.windows.first?.safeAreaInsets.top ?? .zero
    }
}
