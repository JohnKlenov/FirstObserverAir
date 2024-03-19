//
//  CustomAnimateTopView.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 19.03.24.
//

import Foundation

//class AlertTopView: UIView {
//
//
//    let labelWarning: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = .systemFont(ofSize: 15, weight: .medium)
//        label.textAlignment = .center
//        label.textColor = R.Colors.label
//        return label
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        print("init AlertTopView")
//        self.addSubview(labelWarning)
//        setConstraintLabel()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//    private func setConstraintLabel() {
//        NSLayoutConstraint.activate([labelWarning.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//                                     labelWarning.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//                                     labelWarning.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//                                     labelWarning.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)])
//    }
//
//    func setupAlertTopView(labelText: String, backgroundColor: UIColor) {
//        self.backgroundColor = backgroundColor
//        labelWarning.text = labelText
//    }
//
//    deinit {
//        print("deinit AlertTopView")
//    }
//
//
//
//}
//
//
// реализуем на ViewController
//func createTopView(textWarning:String, color: UIColor, comletionHandler: @escaping (AlertTopView) -> Void) {
//    DispatchQueue.main.async {
//        let alert = AlertTopView(frame: CGRect(origin: CGPoint(x: 0, y: -64), size: CGSize(width: self.view.frame.width, height: 64)))
//        alert.setupAlertTopView(labelText: textWarning, backgroundColor: color)
//        self.view.addSubview(alert)
//        comletionHandler(alert)
//    }
//}
//
//func showTopView(title: String, backgroundColor: UIColor) {
//    self.createTopView(textWarning: title, color: backgroundColor) { (alertView) in
//        DispatchQueue.main.async {
//            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {
//                alertView.frame.origin = CGPoint(x: 0, y: -20)
//            }) { (isFinished) in
//                if isFinished {
//                    UIView.animate(withDuration: 0.5, delay: 5, options: .curveEaseOut, animations: {
//                        alertView.frame.origin = CGPoint(x: 0, y: -64)
//                    }) { _ in
//                        alertView.removeFromSuperview()
//                    }
//                }
//            }
//        }
//    }
//}

//                        self?.showTopView(title: "Пароль был сброшен. Пожалуйста, проверьте свою электронную почту.", backgroundColor: R.Colors.systemGreen)

//                        self?.showTopView(title: errorMessage ?? "Something went wrong! Try again!", backgroundColor: R.Colors.systemRed)
