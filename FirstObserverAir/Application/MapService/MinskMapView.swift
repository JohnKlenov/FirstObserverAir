//
//  MinskMapView.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 3.01.24.
//

import UIKit
import MapKit
import FirebaseStorageUI


// мы можем передавать в конструктор arrayPin( в init сразу addAnnotations(arrayPin)), let initialLocation = CLLocation(...), regionMap: CLLocationDistance, и флаг isOnlyHandlerTapGesture

protocol MapViewManagerDelegate: AnyObject {
    func selectAnnotationView(isSelect: Bool)
}

class MinskMapView: MKMapView {

    
    var regionMap: CLLocationDistance = 18000
    
    var arrayPin:[Places] = [] {
        didSet {
            addAnnotations(arrayPin)
        }
    }
    weak var delegateMap: MapViewManagerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
//        calculateRegion()
        isZoomEnabled = false
        isScrollEnabled = false
        isPitchEnabled = false
        isRotateEnabled = false
        
        let initialLocation = CLLocation(latitude: 53.903318, longitude: 27.560448)
        self.centerLocation(initialLocation, regionRadius: regionMap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit MinskMapView")
    }
}

extension MinskMapView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Places else { return nil }
        let identifier = "places"
        var view: MKMarkerAnnotationView

        if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeueView.annotation = annotation
            view = dequeueView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            /// включает отображение выноски (небольшого информационного окна, которое появляется при нажатии на аннотацию) для этого представления аннотации.
            view.canShowCallout = true
            /// цвет глифа (текста или изображения внутри маркера).
            view.glyphTintColor = .black
            /// цвет маркера (фона маркера аннотации) в красный.
            view.markerTintColor = .red
        }

        guard let refImage = annotation.imageName else {
            view.leftCalloutAccessoryView = UIView()
            return view
        }

        let refStorage = Storage.storage().reference(forURL: refImage)
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageView.contentMode = .scaleAspectFit
        imageView.sd_setImage(with: refStorage, placeholderImage: UIImage(named: "DefaultImage")) { image, error, cacheType, storageRef in
            if let _ = error {
                view.leftCalloutAccessoryView = imageView
            } else if let _ = image {
                    view.leftCalloutAccessoryView = imageView
            }
        }
        return view
    }

    /// вызывается, когда пользователь выбирает одно или несколько представлений аннотаций.
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        delegateMap?.selectAnnotationView(isSelect: true)
    }
    /// вызывается, когда пользователь снимает выбор с одного или нескольких представлений аннотаций.
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        delegateMap?.selectAnnotationView(isSelect: false)
    }
}

extension MKMapView {
    func centerLocation(_ location: CLLocation, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    
    }
}




// MARK: - Trash


//    private func calculateRegion() {
//        let onePercent = frame.size.width/100
//        // 3.88 это 1% от т екущей ширины на storyboard
//        let percentWidth = 100 - frame.size.width/onePercent
//        // если > 0 нужно не увеличивать а уменьшать newRegion
//        guard percentWidth > 0 else { return }
//        let plusPercent:Double = Double(Int(percentWidth))/100
////        print(" plusPercent - \(plusPercent)")
//        let newRegion = Int(18000*plusPercent*10)
//
//        regionMap = CLLocationDistance(newRegion)
//    }

//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        guard let annotation = annotation as? Places else { return nil }
//        let identifier = "places"
//        let view: MKMarkerAnnotationView
//
//        if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
//            dequeueView.annotation = annotation
//            view = dequeueView
//        } else {
//            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            view.canShowCallout = true
//            view.glyphTintColor = .black
//            view.markerTintColor = .red
//
//            if let refImage = annotation.imageName {
//                let refStorage = Storage.storage().reference(forURL: refImage)
//                let imageView = UIImageView()
//                imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//                imageView.contentMode = .scaleAspectFit
//                imageView.sd_setImage(with: refStorage, placeholderImage: UIImage(named: "DefaultImage")) { image, error, cacheType, storageRef in
//                    if let _ = error {
////                        print("error - \(error)")
//                    } else {
//                        if let _ = image {
////                            print("image for leftCalloutAccessoryView - \(image)")
//                            DispatchQueue.main.async {
//                                view.leftCalloutAccessoryView = imageView
//                            }
//                        }
//                    }
//                }
//            } else {
//                view.leftCalloutAccessoryView = UIView()
//            }
//        }
//        return view
//    }
    
