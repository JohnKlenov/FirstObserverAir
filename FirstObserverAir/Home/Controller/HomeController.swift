//
//  HomeController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 26.11.23.
//

import UIKit

class HomeController: UIViewController {

    var navController: NavigationController? {
            return self.navigationController as? NavigationController
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
//        navController?.showPlaceholder()
//        navController?.startSpinnerForPlaceholder()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.navController?.stopSpinner()
//            self.navController?.hiddenPlaceholder()
//        }
    }
    
}
