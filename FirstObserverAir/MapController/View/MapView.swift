//
//  MinskMapView.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 3.01.24.
//

import UIKit
import MapKit
import FirebaseStorageUI

protocol MapViewManagerDelegate: AnyObject {
    func selectAnnotationView(isSelect: Bool)
}

final class MapView: MKMapView {
    
    weak var delegateMap: MapViewManagerDelegate?
    
    var places: [Places] = [] {
        didSet {
            removeAnnotations(oldValue)
            addAnnotations(places)
            showAnnotations(places, animated: true)
        }
    }
    
    /// Это второстепенный инициализатор, который должен вызывать и поддерживать один из основных инициализаторов в том же классе. Convenience init позволяет вам предоставить дополнительную логику инициализации или предоставить более простой способ инициализации экземпляра класса. 
    convenience init(places: [Places]) {
        self.init()
        self.places = places
        delegate = self
        addAnnotations(places)
        showAnnotations(places, animated: true)
        setupZoomLimit()
    }
}

// MARK: - Setting
private extension MapView {
    func setupZoomLimit() {
        let zoomLimit = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 1000, maxCenterCoordinateDistance: 100000)
        setCameraZoomRange(zoomLimit, animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension MapView: MKMapViewDelegate {
    
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
            view.glyphTintColor = R.Colors.label
            /// цвет маркера (фона маркера аннотации) в красный.
            view.markerTintColor = R.Colors.systemRed
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
