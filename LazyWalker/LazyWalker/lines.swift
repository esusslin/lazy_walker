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
    
    
    // PRINT FLATTEST ROUTES!
    
    
    func printLine(index: Int, id: String, array: [CLLocationCoordinate2D]) {
        
        let path = paths[index]
        
        let points = path["points"]! as! AnyObject!
        
        
        
        let coords = points?["coordinates"] as! NSArray!
        
        self.distanceElevation(points: coords!, id: id)
        
        var array = array
        
        for coord in coords! {
            
            let coordAry = coord as! NSArray
            
            let elevation = coordAry[2]
            
            elevationRange.append(elevation as! Double)
            
            let lat = coordAry[1]
            let lng = coordAry[0]
            
            let ht = coordAry[2]
            
            let point = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: lng as! CLLocationDegrees)
            
            
            
            add(coordinate: point, id: id)
            
            let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
            
            array.append(coordpoint)
            
        }
        
        
        
        totalDistanceOverall = self.distance(array.first!, array.last!)
        
        
        for (index, _) in array.enumerated() {
            if index == 0 { continue } // skip first
            self.split(array[index - 1], array[index], id)
        }
        
        
        
        let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: array)
        let shape = MGLPolyline(coordinates: pointer, count: UInt(array.count))
        
        shape.title = (id + "REG") as! String!
        
        print("INITIAL TITLE")
        print(shape.title)
        
        
        self.mapView.addAnnotation(shape)
        mapView.selectAnnotation(shape, animated: true)
    }

    
    /// BOLD LINE
    
    func boldline(title: String) {
        
        let num = Int(title)!
        
        let titleString = title
        
        let poly = mapView.annotations?.filter { annotation in
            
            return (annotation.title??.localizedCaseInsensitiveContains("REG") == true)
            
        }
        
        for pol in poly! {
        
        let name = pol.title!
        let id = (title + "REG") as? String
            
            print("ID AND NAME")
            print(id)
            print(name)
            
            if pol.title!! == id! {
                
                mapView.removeAnnotation(pol)
                let shape = pol as! MGLPolyline
                let newtitle = (titleString + "BOLD")
                
                shape.title = newtitle
                
                
                print("EMBOLDENED SHAPE TITLE")
                    print(shape.title)
                    self.mapView.addAnnotation(shape)
            }
        }
        
    }
    
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
    
                print(shape.title)
                self.mapView.addAnnotation(shape)
            }
    
            
            if (name == "3BOLD") {
                    let shape = first as! MGLPolyline
                    shape.title = "3REG"
    
                print(shape.title)
                self.mapView.addAnnotation(shape)
            }
    
    
            if (name == "2BOLD") {
                    let shape = first as! MGLPolyline
                    shape.title = "2REG"
    
                print(shape.title)
                self.mapView.addAnnotation(shape)
            }
    
    
            if (name == "1BOLD") {
                    let shape = first as! MGLPolyline
                    shape.title = "1REG"
    
                print(shape.title)
                self.mapView.addAnnotation(shape)
            }
    
    
            if (name == "0BOLD") {
                    let shape = first as! MGLPolyline
                    shape.title = "0REG"
    
                print(shape.title)
                self.mapView.addAnnotation(shape)
            }
            
        }

    
    }


    // DIVIDE POLYLINE FOR ACCURACY:
    
    
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
            
//            let point = [distanceCounter, htAry[index]] as! NSArray
            
            let point = CGPoint(x: distanceCounter, y: htAry[index])
            
//            print(point)
            
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
    
    
    func distance(_ from: CLLocationCoordinate2D, _ to: CLLocationCoordinate2D) -> Double {
        let fromLoc = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLoc = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLoc.distance(from: toLoc)
    }
    
    func mid(_ from: CLLocationCoordinate2D, _ to: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let latitude = (from.latitude + to.latitude) / 2
        let longitude = (from.longitude + to.longitude) / 2
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    
    

}
