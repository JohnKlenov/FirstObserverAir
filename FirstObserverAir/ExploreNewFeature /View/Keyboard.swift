//
//  Keyboard.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 28.02.24.
//

//import UIKit
//
//class KeyboardButton: UIViewController {
//
//    private var buttonCentre: CGPoint!
//    let signInButton = UIButton()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        signInButton.frame = CGRect(x: 0, y: 0, width: view.frame.width * 0.7, height: 50)
//        /// для размера экранов iPhone 8 (view.frame.height - 100) для iPhone XR (view.frame.height - 150)
//        signInButton.center = CGPoint(x: view.center.x, y: view.frame.height - 150)
//        buttonCentre = signInButton.center
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        addKeyboardObserver()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        removeKeyboardObserver()
//    }
//
//    func addKeyboardObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowSignIn), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideSignIn), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    func removeKeyboardObserver() {
//        NotificationCenter.default.removeObserver(self)
//    }
//
//    @objc func keyboardWillShowSignIn(notification: Notification) {
//
//        let userInfo = notification.userInfo!
//        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//
//        signInButton.center = CGPoint(x: view.center.x, y: view.frame.height - keyboardFrame.height - 15 - signInButton.frame.height/2)
//    }
//
//    @objc func keyboardWillHideSignIn(notification: Notification) {
//        signInButton.center = buttonCentre
//    }
//}
