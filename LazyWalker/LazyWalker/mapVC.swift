//
//  ViewController.swift
//  LazyWalker
//
//  Created by Emmet Susslin on 2/9/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//


import UIKit
import CoreLocation
import CoreData
import Mapbox
import Alamofire



class mapVC: UIViewController, MGLMapViewDelegate {
    
    
    
    let locationManager = CLLocationManager()
    
    var latitude = Double()
    var longitude = Double()
    
    var destination = CLLocationCoordinate2D()
    var destinationDirection = Double()
    
    // FOR ALL ROUTES
    var paths = [[String:Any]]()
    
    // UNIQUE VALUES OF EACH ROUTE
    
    var ascend = [Double]()
    var descend = [Double]()
    var distance = [Double]()


    @IBOutlet var mapView: MGLMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentLocation = locationManager.location
        
        self.latitude = (currentLocation?.coordinate.latitude)!
        self.longitude = (currentLocation?.coordinate.longitude)!
        
        print(self.latitude)
        print(self.longitude)

        
        // map stuff
        
        // Set the map view‘s delegate property
        mapView.delegate = self
        
        mapView.frame = view.bounds
        mapView.styleURL = URL(string: "mapbox://styles/esusslin/cixvherpa00032smn8c7kffjp")
        
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: (self.latitude), longitude: (self.longitude)), zoomLevel: 4, animated: false)
        
        self.destination = CLLocationCoordinate2D(latitude: 37.785733, longitude: -122.437765)
        
       bearingToLocationDegrees(destinationLocation:CLLocation(latitude: 37.785733, longitude: -122.437765))
        
        getGraphopper()
    }
    
    func getGraphopper() {
        
        let destination = self.destination
        
        let destLat = destination.latitude
        let destLong = destination.longitude
        
        print(destLat)
        print(destLong)
        
        let originString = "\(self.latitude)," + "\(self.longitude)"
        
        let deString = "\(destLat)," + "\(destLong)"
        
        let pointstring = originString + "&point=" + deString
        
        print(pointstring)
        
        let theString = "https://graphhopper.com/api/1/route?point=" + pointstring + "&vehicle=foot&locale=en&elevation=true&points_encoded=false&ch.disable=true&heading=1&algorithm=alternative_route&alternative_route.max_paths=20&alternative_route.max_weight_factor=4&alternative_route.max_share_factor=2&key=454360ab-e1b4-4944-874c-e439b9b8a6c1"
        
        print(theString)
        
        
        Alamofire.request(theString).responseJSON { response in
        
            
            
            if let JSON = response.result.value as? [String:Any] {
                
                print(response)
                
                let paths = JSON["paths"] as! [[String:Any]]
                
                print("path options:")
                print(paths.count)
                
                for path in paths {
                    
                    let points = path["points"] as? [String:Any]
                    let coords = points?["coordinates"] as! NSArray!
                    var linecoords = [CLLocationCoordinate2D]()
                    var elevations = [Double]()
                    
                    self.ascend.append((path["ascend"] as? Double)!)
                    self.descend.append((path["descend"] as? Double)!)
                    self.distance.append((path["distance"] as? Double)!)
                
                
                self.paths.append(path)
                }
                
                self.flattestRoute()

            }
            
            }
        }

    
    func flattestRoute() {

        // ASSESS DISTANCE FOR SHORTEST

        let sortedDistance = self.distance.sorted()

        let shortest = self.distance.index(of: sortedDistance[0])!
        
        
        
        // Asses ascension for least demanding route
        
//        print("Ascension values:")
//        print(self.ascend)
        
        let sortedAscend = self.ascend.sorted()

//        print("Sorted Ascension values:")
//        print(sortedAscend)
        
        //FIFTH:
    
            
        let fiveflattest = self.ascend.index(of: sortedAscend[4])!
        printFifth(index: fiveflattest)
        
        //FOURTH:
        let fourflattest = self.ascend.index(of: sortedAscend[3])!
        printFourth(index: fourflattest)

        
        //THIRD:
        let threeflattest = self.ascend.index(of: sortedAscend[2])!
        printThird(index: threeflattest)
            
       
        
        //SECOND:
        let twoflattest = self.ascend.index(of: sortedAscend[1])!
        printSecond(index: twoflattest)
        
        
        // FIRST:
        let flattest = self.ascend.index(of: sortedAscend[0])!
        printFirst(index: flattest)

    }
    
    
    
    // PRINT SHORTEST ROUTE:
    
    func printShortest(index: Int) {
        
//        print("shortest:")
//        print(index)
        let path = self.paths[index]
        
        print("boner")
        
        let points = path["points"]! as! AnyObject!
        let coords = points?["coordinates"] as! NSArray!
        var linecoords = [CLLocationCoordinate2D]()
        for coord in coords! {
            
            let coordAry = coord as! NSArray
            let lat = coordAry[1]
            let lng = coordAry[0]
            
            let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
            
            linecoords.append(coordpoint)
            
        }
        let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: linecoords)
        let shape = MGLPolyline(coordinates: pointer, count: UInt(linecoords.count))
        
        shape.title = "shortest"
        
        self.mapView.addAnnotation(shape)
        
    }
    
    
    
    // PRINT FLATTEST ROUTES!

    
    func printFirst(index: Int) {
        
//        print("flattest:")
//        print(index)
        
        let path = self.paths[index]
        
//        print(path)
        
        let points = path["points"]! as! AnyObject!
                let coords = points?["coordinates"] as! NSArray!
                            var linecoords = [CLLocationCoordinate2D]()
                            for coord in coords! {
        
                                let coordAry = coord as! NSArray
                                let lat = coordAry[1]
                                let lng = coordAry[0]
                                
                                let ht = coordAry[2] as! Double
                                
                                let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
                                
                                linecoords.append(coordpoint)
                                
                            }
                    let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: linecoords)
                    let shape = MGLPolyline(coordinates: pointer, count: UInt(linecoords.count))
        
                    shape.title = "first"
        
                   self.mapView.addAnnotation(shape)

    }
    
    func printSecond(index: Int) {
        
//        print("secondflattest:")
//        print(index)
        
        let path = self.paths[index]
        
        let points = path["points"]! as! AnyObject!
        let coords = points?["coordinates"] as! NSArray!
        var linecoords = [CLLocationCoordinate2D]()
        for coord in coords! {
            
            let coordAry = coord as! NSArray
            let lat = coordAry[1]
            let lng = coordAry[0]
            
            let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
            
            linecoords.append(coordpoint)
            
        }
        let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: linecoords)
        let shape = MGLPolyline(coordinates: pointer, count: UInt(linecoords.count))
        
        shape.title = "second"
        
        self.mapView.addAnnotation(shape)

    }
    
    func printThird(index: Int) {
        
//        print("thirdflattest:")
//        print(index)
        
        let path = self.paths[index]
        
        let points = path["points"]! as! AnyObject!
        let coords = points?["coordinates"] as! NSArray!
        var linecoords = [CLLocationCoordinate2D]()
        for coord in coords! {
            
            let coordAry = coord as! NSArray
            let lat = coordAry[1]
            let lng = coordAry[0]
            
            let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
            
            linecoords.append(coordpoint)
            
        }
        let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: linecoords)
        let shape = MGLPolyline(coordinates: pointer, count: UInt(linecoords.count))
        
        shape.title = "third"
        
       self.mapView.addAnnotation(shape)

        
    }
    
        func printFourth(index: Int) {
            
//            print("fourthflattest:")
//            print(index)
    
            let path = self.paths[index]
    
            //        print(path)
    
            let points = path["points"]! as! AnyObject!
            let coords = points?["coordinates"] as! NSArray!
            var linecoords = [CLLocationCoordinate2D]()
            for coord in coords! {
    
                let coordAry = coord as! NSArray
                let lat = coordAry[1]
                let lng = coordAry[0]

                let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
    
                linecoords.append(coordpoint)
    
            }
            let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: linecoords)
            let shape = MGLPolyline(coordinates: pointer, count: UInt(linecoords.count))
    
            shape.title = "fourth"
    
            self.mapView.addAnnotation(shape)
    
        }
    
        func printFifth(index: Int) {
            
//            print("fifthflattest:")
//            print(index)
    
            let path = self.paths[index]
    
            //        print(path)
    
            let points = path["points"]! as! AnyObject!
            let coords = points?["coordinates"] as! NSArray!
            var linecoords = [CLLocationCoordinate2D]()
            for coord in coords! {
    
                let coordAry = coord as! NSArray
                let lat = coordAry[1]
                let lng = coordAry[0]

                let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
    
                linecoords.append(coordpoint)
    
            }
            let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: linecoords)
            let shape = MGLPolyline(coordinates: pointer, count: UInt(linecoords.count))
    
            shape.title = "fifth"
    
            self.mapView.addAnnotation(shape)
    
        }

    
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        // Set the alpha for all shape annotations to 1 (full opacity)
        return 1
    }
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        // Set the line width for polyline annotations
        return 4.0
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        // Give our polyline a unique color by checking for its `title` property
        
        
        if (annotation.title == "first" && annotation is MGLPolyline) {
            
            print("green")
            
            // Mapbox cyan
            return .green
        }
        if (annotation.title == "second" && annotation is MGLPolyline) {
            
            print("green-yellow")
            
            // Mapbox cyan
            return UIColor(red: 127.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        
        if (annotation.title == "third" && annotation is MGLPolyline) {
            
            print("total-yellow")
            
            // Mapbox cyan
             return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        
        if (annotation.title == "fourth" && annotation is MGLPolyline) {
            
            print("total-yellow")
            
            // Mapbox cyan
            return UIColor(red: 255.0/255.0, green: 150.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        
        if (annotation.title == "fifth" && annotation is MGLPolyline) {
            
            print("total-yellow")
            
            // Mapbox cyan
            return UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
     
        
        if (annotation.title == "shortest" && annotation is MGLPolyline) {
            
            print("red")
            
            return .red
        }

        else
        {
            return .brown
        }

    }
    
    
    
    // DIRECTIONAL BEARING:
    
    func DegreesToRadians(degrees: Double ) -> Double {
        return degrees * M_PI / 180
    }
    
    func RadiansToDegrees(radians: Double) -> Double {
        return radians * 180 / M_PI
    }
    
    func bearingToLocationRadian(destinationLocation:CLLocation) -> Double {
        
        let lat1 = DegreesToRadians(degrees: self.latitude)
        let lon1 = DegreesToRadians(degrees: self.longitude)
        
        let lat2 = DegreesToRadians(degrees: destinationLocation.coordinate.latitude);
        let lon2 = DegreesToRadians(degrees: destinationLocation.coordinate.longitude);
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        let radiansBearing = atan2(y, x)
        
        return radiansBearing
    }
    
    func bearingToLocationDegrees(destinationLocation:CLLocation) -> Double{
        let heading = RadiansToDegrees(radians: bearingToLocationRadian(destinationLocation: destinationLocation))
        print("HEADING THIS DIRECTION:")
        print(heading)
        
        let degrees = (360.0 + heading) as! Double!
        
        print("DEGREES")
        print(degrees)
        
        self.destinationDirection = degrees!
        
        return heading
    }
    
    
    // MAP CAMERA

    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
    
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 6000, pitch: 60, heading: (self.destinationDirection))
        
        
        
        // Animate the camera movement over 5 seconds.
        mapView.setCamera(camera, withDuration: 5, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    }
    
    
}
