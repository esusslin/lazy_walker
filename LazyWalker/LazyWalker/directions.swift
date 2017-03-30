//
//  directions.swift
//  LazyWalker
//
//  Created by Emmet Susslin on 3/27/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import Mapbox
import Alamofire
import Charts
import SwiftCharts
import GooglePlaces


var currentDestination = CLLocationCoordinate2D()
var currentOrigin = CLLocationCoordinate2D()
var currentDestinationDirection = Double()

var distanceArray = [String]()
var textArray = [String]()
var signArray = [String]()
var intervalArray = [NSArray]()
var coordsArray = [NSArray]()

var progCount = Int()

extension mapVC {
    
//    var geotifications = [Geotification]()
//    let locationManager = CLLocationManager() // Add this stdatement


   @objc func toDirections(withSender sender: MyTapGestureRecognizer) {
        print("BONER DIRECTIONS")

        let index = Int(sender.id!)!
    
        let path = paths[index]
    
        let points = path["points"]! as! AnyObject!
        let arrayOfCoords = points?["coordinates"] as! NSArray!
    
        coordsArray = arrayOfCoords as! [NSArray]

        let steps = path["instructions"] as! NSArray!
    
            for step in steps! {
                let each = step as AnyObject!
                
//                print(each)
                
                let dist = each?["distance"]!
                let distString = String(describing: dist!)
                distanceArray.append(distString)
                
                let txt = each?["text"]!
                let txtString = String(describing: txt!)
                textArray.append(txtString)
                
                let sgn = each?["sign"]!
                let sgnString = String(describing: sgn!)
                signArray.append(sgnString)
                
                let interval = each?["interval"] as? NSArray!
//                let interAry = NSArray(array: interval)
                intervalArray.append(interval!)
                
                print(distString)
               
            }
    
    print(distanceArray)
    print(textArray)
    print(distanceArray)
    
    startMap()
    
    }
    
//    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        showAlert("enter \(region.identifier)")
//    }
    
       
    
    
    func startMap() {
        
        progCount += 1
        
        print("COUNTER")
        print(progCount)
        
        setLocation()
        
        let lat = coordsArray[progCount][1]
        let lng = coordsArray[progCount][0]
        
        currentDestination = CLLocationCoordinate2D(latitude:
            lat as! CLLocationDegrees, longitude: lng as! CLLocationDegrees)
        
        bearingToLocationDegreesDirections(destinationLocation:CLLocation(latitude: lat as! CLLocationDegrees, longitude: lng as! CLLocationDegrees))
        
        adjustCameraForDirections()
        geoProgressListener()
    }
    
    func geoProgressListener() {
        
        setLocation()
        
//        let currentLocation = locationManager.location
        
        
    }
    
    
    func mapProgress() {
        
        setLocation()
        
        
        
//        currentDestination = CLLocationCoordinate2D(latitude: lat, longitude: lon)
//        //        self.bearingToLocationDegrees(destinationLocation:destination)
//        
//        bearingToLocationDegrees(destinationLocation:CLLocation(latitude: lat, longitude: lon))

        
        
    }
    
    
    
    
    // MAP CAMERA
    
    //    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
    
    func adjustCameraForDirections() {
        
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 10, pitch: 80, heading: (currentDestinationDirection))
        
//        print("TOTAL DISTANCE")
//        print(totalDistanceOverall)
        
        // Animate the camera movement over 5 seconds.
        mapView.setCamera(camera, withDuration: 3, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        
        self.imageShow()
    }
    
    
    func bearingToLocationRadian(destinationLocation:CLLocation) -> Double {
        
        let lat1 = DegreesToRadians(degrees: latitude)
        let lon1 = DegreesToRadians(degrees: longitude)
        
        print("latlong1")
        print(lat1)
        print(lon1)
        
        let lat2 = DegreesToRadians(degrees: destinationLocation.coordinate.latitude);
        let lon2 = DegreesToRadians(degrees: destinationLocation.coordinate.longitude);
        
        print("latlong2")
        print(lat2)
        print(lon2)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        let radiansBearing = atan2(y, x)
        
        return radiansBearing
    }
    
    func bearingToLocationDegreesDirections(destinationLocation:CLLocation) -> Double{
        let heading = RadiansToDegrees(radians: bearingToLocationRadian(destinationLocation: destinationLocation))
        print("HEADING THIS DIRECTION:")
        print(heading)
        
        let degrees = (360.0 + heading) as! Double!
        
        print("DEGREES")
        print(degrees)
        
        currentDestinationDirection = degrees!
        
        return heading
    }

    
    func bearingToLocationDegrees(destinationLocation:CLLocation) -> Double{
        let heading = RadiansToDegrees(radians: bearingToLocationRadian(destinationLocation: destinationLocation))
        print("HEADING THIS DIRECTION:")
        print(heading)
        
        let degrees = (360.0 + heading) as! Double!
        
        print("DEGREES")
        print(degrees)
        
        destinationDirection = degrees!
        
        return heading
    }



}

//(sender : UITapGestureRecognizer)
