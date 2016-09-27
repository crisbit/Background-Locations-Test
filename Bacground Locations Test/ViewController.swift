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
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var locationsLabel: UILabel!
    
    var locationsReceived: [Location] = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        
        // Load locations
        let locations = Memory.load()
        for location in locations {
            map.addAnnotation(location.makePointAnnotation())
        }
        
        AppDelegate.locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let cLLocation = locations.last!
        
        if UIApplication.shared.applicationState == .background {
            print("SONO IN BACKGROUND e ho ricevuto la posizione: \(cLLocation)")
            if self.locationsReceived.count > 0 && self.locationsReceived.count % 10 == 0 {
                UNUserNotificationCenter.alert(title: "Locations received", body: "\(self.locationsReceived.count)")
            }
        }
        
        if locationsReceived.count == 0 {
            zoomInOnLocation(location: cLLocation)
        }
        
        let location = Location.init(from: cLLocation)
        locationsReceived.append(location)
        Memory.append(location)
        
        map.addAnnotation(location.makePointAnnotation())
        updateLocationsLabel()
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
        map.setRegion(region, animated: false)
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
        locationsLabel.text = "Locations received\n\(locationsReceived.count)"
    }

    @IBAction func resetButtonTapped() {
        locationsReceived.removeAll()
        updateLocationsLabel()
        map.removeAnnotations(map.annotations)
        map.removeOverlays(map.overlays)
        Memory.reset()
    }
    
}
