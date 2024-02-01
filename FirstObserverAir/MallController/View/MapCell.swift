//
//  MapCell.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 28.01.24.
//

import UIKit
import MapKit

protocol MapCellDelegate: AnyObject {
    func mapViewTapped()
}

final class MapCell: UICollectionViewCell {
    
    static var reuseID: String = "MapCell"
    private var mapView: MapView!
    private var isMapSelected = false
    private let mapTapGestureRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        return tapRecognizer
    }()
    
    weak var delegate: MapCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMapView(with: [])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit MapCell")
    }
}

// MARK: - Setting Views
private extension MapCell {
    func setupMapView(with arrayPin: [Places]) {
        mapView = MapView(places: arrayPin)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.cornerRadius = 10
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.delegateMap = self
        mapTapGestureRecognizer.addTarget(self, action: #selector(didTapRecognizer(_:)))
        mapView.addGestureRecognizer(mapTapGestureRecognizer)
        
        contentView.addSubview(mapView)
        setupConstraints()
    }
}

// MARK: - Setting
extension MapCell {
    func configureCell(with arrayPin: [Places]) {
        mapView.places = arrayPin
    }
}

// MARK: - Layout
private extension MapCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Selector
private extension MapCell {
    @objc func didTapRecognizer(_ sender: UITapGestureRecognizer) {
        // Обработка нажатия на карту
        let point = sender.location(in: mapView)
        var didTapOnAnnotationView = false
        /// Находится ли точка нажатия внутри annotationMarker
        for annotation in mapView.annotations {
            guard let annotationView = mapView.view(for: annotation),
                  let annotationMarker = annotationView as? MKMarkerAnnotationView,
                  annotationMarker.point(inside: mapView.convert(point, to: annotationMarker), with: nil)
                    /// Если условие guard не выполняется, цикл продолжается с следующей аннотацией.
            else {
                continue
            }
            /// Если условие guard выполняется, то есть нажатие было на представление аннотации, переменная didTapOnAnnotationView устанавливается в true и цикл прерывается.
            didTapOnAnnotationView = true
            break
        }
        
        if !didTapOnAnnotationView && isMapSelected == false {
            delegate?.mapViewTapped()
        }
    }
}

// MARK: - MapViewManagerDelegate
extension MapCell: MapViewManagerDelegate {
    func selectAnnotationView(isSelect: Bool) {
        isMapSelected = isSelect
    }
}

