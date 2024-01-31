//
//  MapController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 13.01.24.
//

import UIKit
import MapKit
import FirebaseStorageUI

final class MapController: UIViewController {

    private var mapView: MapView!
    // Объект, который вы используете для мониторинга местоположения, в вашем приложении.
    private let locationManager = CLLocationManager()
    private var arrayPin: [Places]
    
    private let closeView: XMarkView = {
        let view = XMarkView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let closeViewTapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.numberOfTapsRequired = 1
        return recognizer
    }()
    
        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .all // Разрешить все ориентации для этого контроллера
        }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        get {
//            return .lightContent
//        }
//    }
    init(arrayPin: [Places]) {
        self.arrayPin = arrayPin
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationEnabled()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SettingScreenOrientation.lockOrientation(.all)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SettingScreenOrientation.lockOrientation(.portrait)
    }
}


// MARK: - Setting Views
private extension MapController {
    func setupView() {
        mapView = MapView(places: arrayPin)
        view.addSubview(mapView)
        closeViewTapGestureRecognizer.addTarget(self, action: #selector(didTapCloseView(_:)))
        closeView.addGestureRecognizer(closeViewTapGestureRecognizer)
        mapView.addSubview(closeView)
        setupConstraints()
    }
}

// MARK: - Layout
private extension MapController {
    func setupConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        closeView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20).isActive = true
        closeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        closeView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        closeView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

// MARK: - Selectors
private extension MapController {
    @objc func didTapCloseView(_ gestureRcognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Seeting CLLocationManager
extension MapController {
    // включена ли у нас служба геолокации на устройстве если true то включена.
    func checkLocationEnabled() {
        
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkAuthorization()
        } else {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.isOffLocationService = true
                showSettingAlert(title: "Location service turned off!", message: "Wanna turn on?", url: URL(string: "App-Prefs:root=LOCATION_SERVICES")) {
                    sceneDelegate.isOffLocationService = false
                }
            }
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // получить разрешение пользователя на использование его место положения в Application
    func checkAuthorization() {
        let autorizationStatus: CLAuthorizationStatus = locationManager.authorizationStatus
        
        switch autorizationStatus {
            /// Если пользователь еще не предоставил разрешение на использование службы геолокации, код запрашивает разрешение с помощью метода requestWhenInUseAuthorization()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            /// Если приложению запрещено использовать службы геолокации из-за активных ограничений, например, родительского контроля, код ничего не делает
        case .restricted:
            break
            /// Если пользователь отказал в доступе к службам геолокации, код показывает предупреждающее сообщение с предложением изменить настройки
        case .denied:
            showSettingAlert(title: "You have prohibited the use of location in the application!", message: "Want to change this?", url: URL(string: UIApplication.openSettingsURLString))
            /// Если пользователь разрешил приложению использовать службы геолокации в любое время, код ничего не делает
        case .authorizedAlways:
            mapView.showsUserLocation = true
            /// Если пользователь разрешил приложению использовать службы геолокации только при использовании приложения, код включает отображение местоположения пользователя на карте
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            /// Это обрабатывает любые будущие значения, которые могут быть добавлены в CLAuthorizationStatus, но которые в настоящее время не известны
        @unknown default:
            break
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MapController: CLLocationManagerDelegate {
    ///  реагировать на изменения статуса авторизации службы геолокации и выполнять необходимые действия в ответ на эти изменения
    ///  вызывается, когда статус авторизации службы геолокации изменяется
    ///  зашёл в settings и нажал запретить использовать геолокацию в этом App сработает метод didChangeAuthorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }
}



