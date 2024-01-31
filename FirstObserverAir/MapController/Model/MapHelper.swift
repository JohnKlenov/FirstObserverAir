//
//  MapHelper.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 31.01.24.
//

import Foundation
import MapKit

class MapHelper {
    
    static func convertFromPinInPlaces(pins:[Pin]) -> [Places] {
        var arrayPin:[Places] = []
        pins.forEach { pin in
            if let latitude = pin.latitude, let longitude = pin.longitude {
                let pinMap = Places(title: pin.name, locationName: pin.address, discipline: pin.typeMall, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), imageName: pin.refImage)
                arrayPin.append(pinMap)
            }
        }
        return arrayPin
    }
}

