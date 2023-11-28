//
//  UITabBarController + ext.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 27.11.23.
//

import Foundation
import UIKit

extension UITabBarController {
    func addTabBarSeparator() {
        let topline = CALayer()
        topline.frame = CGRect(x: 0, y: 0, width: self.tabBar.frame.width, height: 0.2)
        topline.backgroundColor = R.Colors.separator.cgColor
        self.tabBar.layer.addSublayer(topline)
    }
}
