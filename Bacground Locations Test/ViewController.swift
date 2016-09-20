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

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

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
        
        map.delegate = self
        
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
        if locationsReceived == 0 {
            zoomInOnLocation(location: locations[0])
        }
        
        locationsReceived += locations.count
        
        let newLocations = locations.map { ccLocation in
            return Location.init(from: ccLocation)
        }
        
        for location in newLocations {
            map.addAnnotation(location.makePointAnnotation())
        }
        
        Memory.append(locations: newLocations)
        
        updatePolyLine()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.blue
        polylineRenderer.lineWidth = 1.5
        return polylineRenderer
    }
    
    func zoomInOnLocation(location: CLLocation) {
        let location = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region = MKCoordinateRegionMake(location, MKCoordinateSpanMake(0.005, 0.005))
        map.setRegion(region, animated: true)
    }
    
    func updatePolyLine() {
        map.removeOverlays(map.overlays)
        var points = [CLLocationCoordinate2D]()
        for location in Memory.load() {
            let point = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            points.append(point)
        }
        let polyline = MKPolyline(coordinates: points, count: points.count)
        map.add(polyline)
    }
    
    func updateLocationsLabel() {
        locationsLabel.text = "Locations received\n\(locationsReceived)"
    }

    @IBAction func resetButtonTapped() {
        locationsReceived = 0
        map.removeAnnotations(map.annotations)
        map.removeOverlays(map.overlays)
        Memory.reset()
    }
    
}
