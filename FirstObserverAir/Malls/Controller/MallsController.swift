//
//  MallsController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 26.11.23.
//

import UIKit

// Протокол для обработки полученных данных
protocol MallsModelOutput:AnyObject {
    func updateData(data: [PreviewSection]?, error: Error?)
}

class MallsController: UIViewController {

    private var mallsModel: MallsModelInput?
    var navController: NavigationController? {
            return self.navigationController as? NavigationController
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.Colors.systemBackground
        mallsModel = MallsFirebaseService(output: self)
    }
    
}

// MARK: - Setting Views
private extension MallsController {
    
    func setupView() {
        
    }
}

// MARK: - Setting
private extension MallsController {
    
    func startLoadFirst() {
        startSpiner()
        setUserInteraction(false)
    }
    
    func startLoadFollowing() {
        startSpiner()
        setViewUserInteraction(false)
    }
    
    func stopLoad() {
        stopSpiner()
        setUserInteraction(true)
    }
    
    func startSpiner() {
        navController?.startSpinnerForWindow()
    }
    
    func stopSpiner() {
        navController?.stopSpinner()
    }
    
}

extension MallsController:MallsModelOutput {
    func updateData(data: [PreviewSection]?, error: Error?) {
        print("")
    }
    
    
}
