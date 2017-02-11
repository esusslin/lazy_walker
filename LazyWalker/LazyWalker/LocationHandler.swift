//
//  LocationHandler.swift
//  LazyWalker
//
//  Created by Chunyu Ou on 2/10/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHandler: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager
    
    var coordinate: CLLocationCoordinate2D?
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    deinit {
        locationManagerStop()
    }
    
    func locationManagerStart() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManagerStop() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: CLLocation Delegate
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        coordinate = newLocation.coordinate
    }
}
