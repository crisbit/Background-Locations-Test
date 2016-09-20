//
//  ViewController.swift
//  Bacground Locations Test
//
//  Created by Cristian Bellomo on 16/09/16.
//  Copyright © 2016 Grocerest. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var locationsLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var locationsReceived: Int = 0 {
        didSet {
            updateLocationsLabel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load locations
        let locations = Memory.load()
        for location in locations {
            map.addAnnotation(location.makePointAnnotation())
        }
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationsReceived += locations.count
        
        let newLocations = locations.map { ccLocation in
            return Location.init(fromCLLocation: ccLocation)
        }
        
        for location in newLocations {
            map.addAnnotation(location.makePointAnnotation())
        }
        
        Memory.append(locations: newLocations)
    }
    
    func updateLocationsLabel() {
        locationsLabel.text = "Locations received\n\(locationsReceived)"
    }

    @IBAction func resetButtonTapped() {
        locationsReceived = 0
        map.removeAnnotations(map.annotations)
        Memory.reset()
    }
    
}

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

class Memory {
    
    private static let defaults = UserDefaults.standard
    
    static func load() -> [Location] {
        let dictionaryLocations = defaults.array(forKey: "locations")

        guard dictionaryLocations != nil else { return [Location]() }

        var locations = [Location]()
        for dictLocation in dictionaryLocations as! [[String: Any]] {
            locations.append(Location(fromDictionary: dictLocation))
        }
        return locations
    }
    
    static func save(locations: [Location]) {
        var dictLocations = [[String: Any]]()
        for location in locations {
            dictLocations.append(location.toDictionary())
        }
        defaults.set(dictLocations, forKey: "locations")
    }
    
    static func append(locations newLocations: [Location]) {
        var locations = self.load()
        locations += newLocations
        self.save(locations: locations)
    }
    
    static func reset() {
        defaults.removeObject(forKey: "locations")
    }
    
}
