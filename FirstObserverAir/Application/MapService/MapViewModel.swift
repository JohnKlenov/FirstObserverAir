//
//  MapViewModel.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 3.01.24.
//

import Foundation
import MapKit


class Places: NSObject, MKAnnotation {
    
    let title: String?
    let locationName: String?
    let discipline: String?
    let imageName: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title:String?, locationName:String?, discipline:String?, coordinate: CLLocationCoordinate2D, imageName: String?) {
        
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.imageName = imageName
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
}
