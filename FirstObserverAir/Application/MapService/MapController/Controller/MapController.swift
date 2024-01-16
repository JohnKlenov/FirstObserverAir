//
//  MapController.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 13.01.24.
//

import UIKit
import MapKit
import FirebaseStorageUI

class MapController: UIViewController {

    private var mapView: MinskMapView!
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
//        AppUtility.lockOrientation(.all)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        AppUtility.lockOrientation(.portrait)
    }
}

// MARK: - Setting Views
private extension MapController {
    func setupView() {
        mapView = MinskMapView(places: arrayPin)
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
            
            // включили geolocation, вернулись в App сработал func sceneDidBecomeActive(_ scene: UIScene)
            // если мы отменили Alert и не пошли в Settings - SceneDelegate.flag = true
            // И если мы перейдем в другую App а затем вернемся в эту сработает func sceneDidBecomeActive(_ scene: UIScene) ????
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
        
        let autorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14, *) {
            print("curent iOS >= iOS 14")
            autorizationStatus = locationManager.authorizationStatus
        } else {
            autorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        switch autorizationStatus {
            
        case .notDetermined:
            print(".notDetermined")
            // вызываем запрос на разрешение использовать место положения user в Application
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            showSettingAlert(title: "You have prohibited the use of location in the application!", message: "Want to change this?", url: URL(string: UIApplication.openSettingsURLString))
        case .authorizedAlways:
            // ????
            break
        case .authorizedWhenInUse:
            print(".authorizedWhenInUse - разрешить в момент использования")
            mapView.showsUserLocation = true
            //            locationManager.requestLocation()
            //  .requestLocation() это метод который один раз запрашивает геопозицию пользователя.
            //            locationManager.startUpdatingLocation()
        @unknown default:
            print("@unknown default")
            break
        }
    }
}

// MARK: -
extension MapController {
    
}

// MARK: - CLLocationManagerDelegate
extension MapController: CLLocationManagerDelegate {
    // если user поменял авторизацию у нас опять все сломается и нам нужно вызвать checkAuthorization()
    // если ты в момент использования App зашёл в settings и нажал запретить использовать геолокацию в этом App
    // сработает метод didChangeAuthorization и мы опять вызовем  checkAutorization()
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }
}



