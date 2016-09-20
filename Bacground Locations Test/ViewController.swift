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
