//
//  lines.swift
//  LazyWalker
//
//  Created by Emmet Susslin on 3/15/17.
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

extension mapVC {
    
    
    
    
    // FUNCITON TO APPLY POLYLINE REPRESENTATION ONTO THE MAP
    
    func printLine(index: Int, id: String, array: [CLLocationCoordinate2D]) {
        
        // PATH IS ACCESSED VIA THE INDEX (FROM THE 'SORTED-ASCEND' EVALUATION)
        let path = paths[index]
       
        // GEOPOINTS ALONG THE ROUTE ARE UNPACKED INTO THIS ARRAY
        let points = path["points"]! as! AnyObject!
        
        // ..COORDINATES OF EACH GEOPOINT HERE
        let coords = points?["coordinates"] as! NSArray!
        
        // THE COORDINATES ARE FED INTO THIS FUNCTION DO ACHIEVE A SET OF POINTS FOR 'DISTANCE/ELEVATION' 
        // THIS DATA SET WILL BE USED FOR A VISUAL REPRESENTATION OF THE ELEVATION CHALLENGES OF EACH ROUTE FOR THE USER
        self.distanceElevation(points: coords!, id: id)
        
        
        // THE EMPTY ARRAY IS PREPARED TO TAKE IN THE LATITUDE/LONGITUDE VALUES FOR EACH ROUTE
        var array = array
        
        
        for coord in coords! {
            
            let coordAry = coord as! NSArray
            
            let elevation = coordAry[2]
            
            elevationRange.append(elevation as! Double)
            
            let lat = coordAry[1]
            let lng = coordAry[0]
            
            let ht = coordAry[2]
            
            let point = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: lng as! CLLocationDegrees)
            
            
            // POINTS ARE SENT TO THIS FUNCITON TO DIVIDE THEM UP INTO SMALLER INCREMENTS
            // WHICH ARE APPLIED TO THE MAP AS 'TAP-ABLE' ANNOTATIONS
            
            add(coordinate: point, id: id)
            
            let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
            
            // THE EMPTY ARRAY ORIGINALL FED INTO THE FUNCTION AS THE LAST ARGUMENT IS POPULATED WITH THE PATH'S LAT/LNG COORDINATE POINTS
            array.append(coordpoint)
            
        }
        
        // TOTAL DISTANCE VARIABLE IS POULATED
        totalDistanceOverall = self.distance(array.first!, array.last!)
        
        // THE COORDINATES ARE FED INTO THIS FUNCITON WHICH EXPANDS THE SET OF COORDINATES
        //.. TO COORDINATES THAT ARE LESS THAN 40 METERS APART
        
        // THIS IS DONE TO HELP WITH THE ACCURACY OF THE POLYLINE ILLUSTRATION ON THE MAP
        
        for (index, _) in array.enumerated() {
            if index == 0 { continue } // skip first
            self.split(array[index - 1], array[index], id)
        }
        
        // THIS IS THE "SAUSAGE-MAKING" OF TURNING COORDINATE POINTS INTO A POLYLINE ON THE MAP:
        
        // COORDINATES ARE CONVERTED INTO AN 'UNSAFEMUTABLEPOINTER' WHICH IS USED TO CREATE A SINGLE POLYLINE OBJECT
        
        let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: array)
        let shape = MGLPolyline(coordinates: pointer, count: UInt(array.count))
        
        // THE SHAPE IS GIVEN A TITLE, WHICH WILL BE USED/INVOKED BY THE USER ACTIVITY
        shape.title = (id + "REG") as! String!

        // POLYLINE IS APPLIED TO THE MAP
        self.mapView.addAnnotation(shape)
        mapView.selectAnnotation(shape, animated: true)
    }

    
    /// BOLDLINE:  FUNCITON IS CALLED WHEN THE USER TAPS ON THE LINE OR SELECTS THE LINE VIA THE MENU
    
    func boldline(title: String) {
        
        // LINE IS FOUND ON THE MAP AND RENAMED TO ACHIEVE A BOLD REPRESENTATION ON THE MAP
        
        let num = Int(title)!
        
        let titleString = title
        
        let poly = mapView.annotations?.filter { annotation in
            
            return (annotation.title??.localizedCaseInsensitiveContains("REG") == true)
            
        }
        
        for pol in poly! {
        
        let name = pol.title!
        let id = (title + "REG") as? String

            if pol.title!! == id! {
                mapView.removeAnnotation(pol)
                let shape = pol as! MGLPolyline
                let newtitle = (titleString + "BOLD")
                shape.title = newtitle
                    self.mapView.addAnnotation(shape)
            }
        }
        
    }
    
    
    // THE BOLD LINE ON THE MAP (CAN ONLY BE ONE) IS FOUND AND RENAMED TO REDUCE WIDTH TO REGULAR SIZE
    func removeBold() {
    
        let poly = mapView.annotations?.filter { annotation in
            return (annotation.title??.localizedCaseInsensitiveContains("BOLD") == true)
        }
    
        if (poly!.count > 0) {
            let first = poly?.first!
            mapView.removeAnnotation(first!)

            let name = first!.title!
            if (name == "4BOLD") {
                let shape = first as! MGLPolyline
                shape.title = "4REG"
                self.mapView.addAnnotation(shape)
            }
    
            
            if (name == "3BOLD") {
                    let shape = first as! MGLPolyline
                    shape.title = "3REG"

                self.mapView.addAnnotation(shape)
            }
    
    
            if (name == "2BOLD") {
                    let shape = first as! MGLPolyline
                    shape.title = "2REG"
                self.mapView.addAnnotation(shape)
            }
    
    
            if (name == "1BOLD") {
                    let shape = first as! MGLPolyline
                    shape.title = "1REG"
                self.mapView.addAnnotation(shape)
            }
    
    
            if (name == "0BOLD") {
                    let shape = first as! MGLPolyline
                    shape.title = "0REG"
                self.mapView.addAnnotation(shape)
            }
            
        }

    }


    // DIVIDE POLYLINE FOR ACCURACY:
    
    // COORDINATES PROVIDED BY THE API CALL ARE DIVIDED INTO SMALLER DISTANCES (less than 40 meters) AND APPLIED TO THE MAP 
    // THESE BARELY-VISIBLE ANNOTATIONS PROVIDED THE USER WITH THE ABILITY TO 'TAP' ANY OF THE POLYLINES FOR EVALUATION
    
    
    func add(coordinate: CLLocationCoordinate2D, id: String) {
        DispatchQueue.main.async {
            // Unowned reference to self to prevent retain cycle
            
            let point = pathAnnotation()
            point.coordinate = coordinate
            point.title = id
            //            point.subtitle = "\(coordinate.latitude) / \(coordinate.longitude)"
            self.mapView.addAnnotation(point)
        }
    }
    
    func split(_ from: CLLocationCoordinate2D, _ to: CLLocationCoordinate2D, _ id: String) {
        
        if distance(from, to) > 40 { // THRESHOLD is 200m
            let middle = mid(from, to)
            add(coordinate: middle, id: id)
            split(from, middle, id)
            split(middle, to, id)
        }
        
        add(coordinate: from, id: id)
        add(coordinate: to, id: id)
        
        
    }
    
    
    
    
    func distanceElevation(points: NSArray, id: String) {
        
        var coordAry = [CLLocationCoordinate2D]()
        
        var htAry = [Double]()
        
        for point in points {
            
            let pointAry = point as! NSArray
            
            htAry.append(pointAry[2] as! Double)
            
            let coordinates = CLLocationCoordinate2D(latitude: pointAry[1] as! CLLocationDegrees, longitude: pointAry[0] as! CLLocationDegrees)
            
            coordAry.append(coordinates)
        }
        
        var distanceCounter = 0.0
        
        for (index, _) in coordAry.enumerated() {
            
            if index == 0 { continue } // skip first
            
            
            let distance = self.distance(coordAry[index - 1], coordAry[index])
            distanceCounter += distance
            let point = CGPoint(x: distanceCounter, y: htAry[index])
            
            if id == "0" {
                firstCoords.append(point)
            }
            if id == "1" {
                secondCoords.append(point)
            }
            if id == "2" {
                thirdCoords.append(point)
            }
            
            if id == "3" {
                fourthCoords.append(point)
            }
            
            if id == "4" {
                fifthCoords.append(point)
            }
            
            
        }
        

    }
    
    
    // FUNCTION TO QUICKLY ASSESS DISTANCE BETWEEN TWO LAT/LNG COORDINATES
    
    func distance(_ from: CLLocationCoordinate2D, _ to: CLLocationCoordinate2D) -> Double {
        let fromLoc = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLoc = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLoc.distance(from: toLoc)
    }
    
    
    // FUNCTION TO QUICKLY FIND THE MIDDLE POINT OF TWO LAT/LNG COORDINATES
    
    
    func mid(_ from: CLLocationCoordinate2D, _ to: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let latitude = (from.latitude + to.latitude) / 2
        let longitude = (from.longitude + to.longitude) / 2
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    
    

}
