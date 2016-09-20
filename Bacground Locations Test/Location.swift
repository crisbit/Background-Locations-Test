//
//  Location.swift
//  Bacground Locations Test
//
//  Created by Cristian Bellomo on 20/09/16.
//  Copyright © 2016 Grocerest. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

struct Location {
    var longitude: Double
    var latitude: Double
    var title: String
    
    init(fromCLLocation location: CLLocation) {
        longitude = location.coordinate.longitude
        latitude = location.coordinate.latitude
        title = "\(location.timestamp)"
    }
    
    init(fromDictionary dict: [String: Any]) {
        longitude = dict["longitude"] as! Double
        latitude = dict["latitude"] as! Double
        title = dict["title"] as! String
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "longitude": self.longitude,
            "latitude": self.latitude,
            "title": self.title
        ]
    }
    
    func makePointAnnotation() -> MKPointAnnotation {
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = CLLocationCoordinate2D(
            latitude: self.latitude,
            longitude: self.longitude
        )
        dropPin.title = self.title
        return dropPin
    }
    
}
