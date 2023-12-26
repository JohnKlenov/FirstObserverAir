//
//  NavigationController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 26.11.23.

import UIKit

final class NavigationController: UINavigationController {

    private var placeholderView: PlaceholderView?
   
    private lazy var activityView: ActivityContainerView = {
        let view = ActivityContainerView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}
    
    
// MARK: - Setting Views
private extension NavigationController {
    
    func setupView() {
        navigationBar.tintColor = R.Colors.label
        configurePlaceholderView()
    }
}


// MARK: - Setting
extension NavigationController {
    
//    setup placeholderView
    private func configurePlaceholderView() {
        
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        placeholderView = PlaceholderView(frame:frame)
        
        if let placeholderView = placeholderView {
            view.addSubview(placeholderView)
            // Перемещает указанное подпредставление так, чтобы оно отображалось позади своих одноуровневых элементов.
            view.sendSubviewToBack(placeholderView)
            // Перемещает указанное подпредставление так, чтобы оно отображалось поверх своих одноуровневых элементов.
            //            view.bringSubviewToFront(placeholderView)
        }
        hiddenPlaceholder()
    }
    
    func showPlaceholder() {
        // Показать placeholder view и скрыть содержимое контроллера
        topViewController?.view.isHidden = true
        placeholderView?.isHidden = false
    }
    
    func hiddenPlaceholder() {
        // Скрыть placeholder view и показать содержимое контроллера
        topViewController?.view.isHidden = false
        placeholderView?.isHidden = true
    }
    
    func checkIfPlaceholderIsHidden(completion: (Bool) -> Void) {
        if let isHidden = placeholderView?.isHidden, isHidden {
            completion(true)
        } else {
            completion(false)
        }
    }
    
//    setup activityIndicatorView
    
    private func setupSpinner(in view: UIView) {
        view.addSubview(activityView)
        setupCnstrForActivityView(activityView: activityView, in: view)
    }

    /// placeholder
    func startSpinnerForPlaceholder() {
        if let placeholderView = placeholderView {
            setupSpinner(in: placeholderView)
            activityView.startAnimating()
        }
    }
    
    /// view
    func startSpinnerForView() {
        if let view = topViewController?.view {
            setupSpinner(in: view)
            activityView.startAnimating()
        }
    }

    ///window
    func startSpinnerForWindow() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            setupSpinner(in: window)
            activityView.startAnimating()
        }
    }

    func stopSpinner() {
        activityView.stopAnimating()
        activityView.removeFromSuperview()
    }
}


// MARK: - Layout
private extension NavigationController {
    func setupCnstrForActivityView(activityView: ActivityContainerView, in view:UIView) {
        activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4).isActive = true
        activityView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4).isActive = true
    }
}
