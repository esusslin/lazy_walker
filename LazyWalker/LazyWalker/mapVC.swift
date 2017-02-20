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
    
    //    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    
    let locationManager = CLLocationManager()
    
    var latitude: Double?
    
    var longitude: Double?
    
    var paths = [[String:Any]]()
    
    var avgs = [Double]()
    var firstHts = [Double]()
    var secondHts = [Double]()
    var thirdHts = [Double]()
    var shortestHts = [Double]()
    
    var ascend = [Double]()
    
    var descend = [Double]()
    
    var distance = [Double]()
    var polylines = [MGLPolyline]()

    @IBOutlet var mapView: MGLMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentLocation = locationManager.location
        
        self.latitude = currentLocation?.coordinate.latitude
        self.longitude = currentLocation?.coordinate.longitude
        
        print(self.latitude!)
        print(self.longitude!)

        
        
        // map stuff
        
        // Set the map view‘s delegate property
        mapView.delegate = self
        
        mapView.frame = view.bounds
        mapView.styleURL = URL(string: "mapbox://styles/esusslin/cixvherpa00032smn8c7kffjp")
        
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: (self.latitude!), longitude: (self.longitude!)), zoomLevel: 4, animated: false)
        
       
        
        getGraphopper()
    }
    
    func getGraphopper() {
        
        let theString = "https://graphhopper.com/api/1/route?point=37.784785,-122.397684&point=37.739474,-122.470126&vehicle=foot&locale=en&elevation=true&points_encoded=false&ch.disable=true&algorithm=alternative_route&alternative_route.max_paths=20&alternative_route.max_weight_factor=4&alternative_route.max_share_factor=2&key=454360ab-e1b4-4944-874c-e439b9b8a6c1"
        
        Alamofire.request(theString).responseJSON { response in
        
            
            if let JSON = response.result.value as? [String:Any] {
                
                let paths = JSON["paths"] as! [[String:Any]]
                
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

        // Assess Distance for shortest route
        
        print("DISTANCE:")
        print(self.distance)
        
        let sortedAscend = self.ascend.sorted()
        let sortedDistance = self.distance.sorted()
        print("SORTED DISTANCE:")
        print(sortedDistance)
        
    
        let shortest = self.distance.index(of: sortedDistance[0])!
        let flattest = self.ascend.index(of: sortedAscend[0])!
        
//        print(shortest)
//
        printShortest(index: shortest)
        
        let twoflattest = self.ascend.index(of: sortedAscend[1])!
        
        printFirst(index: flattest)
        
        let threeflattest = self.ascend.index(of: sortedAscend[2])!
        
        printSecond(index: twoflattest)
        
        let fourflattest = self.ascend.index(of: sortedAscend[3])!
        
        printThird(index: threeflattest)
        
        let fiveflattest = self.ascend.index(of: sortedAscend[4])!
        
//        printFourth(index: fourshortest)
        
        let sixshortest = self.ascend.index(of: sortedAscend[5])!
        
//        printFifth(index: fiveshortest)
        
        let sevenshortest = self.ascend.index(of: sortedAscend[6])!
        
//        printSixth(index: sixshortest)
        
    
//        printSeventh(index: sevenshortest)
        
        
//        // Asses ascension for least demanding route
//
//        let sortedAscend = self.ascend.sorted()
//        
//        print(sortedAscend)
//
//        let first = self.ascend.index(of: sortedAscend[0])!
//        
//        print("FIRST!")
//        print(first)
//        print(self.distance[first])
//
//        printFirst(index: first)
//        
//        let second = self.ascend.index(of: sortedAscend[1])!
//        
//        print("SECOND!")
//        print(second)
//        print(self.distance[second])
//
//        printSecond(index: second)
//        
//        
//        let third = self.ascend.index(of: sortedAscend[2])!
//        
//        print("THIRD!")
//        print(third)
//        print(self.distance[third])
//
//        printThird(index: third)
//        
//        printShortest(index: shortest)

    }
    
    func printShortest(index: Int) {
        
        print("shortest:")
        print(index)
        let path = self.paths[index]
        
        print("boner")
        
        let points = path["points"]! as! AnyObject!
        let coords = points?["coordinates"] as! NSArray!
        var linecoords = [CLLocationCoordinate2D]()
        for coord in coords! {
            
            let coordAry = coord as! NSArray
            let lat = coordAry[1]
            let lng = coordAry[0]
            
            let ht = coordAry[2] as! Double
            
            self.shortestHts.append(ht)
            
            let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
            
            linecoords.append(coordpoint)
            
        }
        let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: linecoords)
        let shape = MGLPolyline(coordinates: pointer, count: UInt(linecoords.count))
        
        shape.title = "shortest"
        
        self.polylines.append(shape)
        
        self.mapView.addAnnotation(shape)
        
    }

    
    func printFirst(index: Int) {
        
        print("flattest:")
        print(index)
        
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
                                
                                self.firstHts.append(ht)
        
                                let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
                                
                                linecoords.append(coordpoint)
                                
                            }
                    let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: linecoords)
                    let shape = MGLPolyline(coordinates: pointer, count: UInt(linecoords.count))
        
                    shape.title = "first"
        
        self.polylines.append(shape)
        
                   self.mapView.addAnnotation(shape)

    }
    
    func printSecond(index: Int) {
        
        print("secondflattest:")
        print(index)
        
        let path = self.paths[index]
        
        let points = path["points"]! as! AnyObject!
        let coords = points?["coordinates"] as! NSArray!
        var linecoords = [CLLocationCoordinate2D]()
        for coord in coords! {
            
            let coordAry = coord as! NSArray
            let lat = coordAry[1]
            let lng = coordAry[0]
            
            let ht = coordAry[2] as! Double
            
            self.secondHts.append(ht)
            
            let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
            
            linecoords.append(coordpoint)
            
        }
        let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: linecoords)
        let shape = MGLPolyline(coordinates: pointer, count: UInt(linecoords.count))
        
        shape.title = "second"
        
        self.mapView.addAnnotation(shape)
        self.polylines.append(shape)
        
    }
    
    func printThird(index: Int) {
        
        print("thirdflattest:")
        print(index)
        
        let path = self.paths[index]
        
        let points = path["points"]! as! AnyObject!
        let coords = points?["coordinates"] as! NSArray!
        var linecoords = [CLLocationCoordinate2D]()
        for coord in coords! {
            
            let coordAry = coord as! NSArray
            let lat = coordAry[1]
            let lng = coordAry[0]
            
            let ht = coordAry[2] as! Double
            
            self.thirdHts.append(ht)
            
            let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
            
            linecoords.append(coordpoint)
            
        }
        let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: linecoords)
        let shape = MGLPolyline(coordinates: pointer, count: UInt(linecoords.count))
        
        shape.title = "third"
        
        self.polylines.append(shape)
        
//        goPolylines()
        
       self.mapView.addAnnotation(shape)

        
    }
    
    func printFourth(index: Int) {
        
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
            
            self.firstHts.append(ht)
            
            let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
            
            linecoords.append(coordpoint)
            
        }
        let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: linecoords)
        let shape = MGLPolyline(coordinates: pointer, count: UInt(linecoords.count))
        
        shape.title = "fourth"
        
        self.polylines.append(shape)
        
        self.mapView.addAnnotation(shape)
        
    }
    
    func printFifth(index: Int) {
        
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
            
            self.firstHts.append(ht)
            
            let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
            
            linecoords.append(coordpoint)
            
        }
        let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: linecoords)
        let shape = MGLPolyline(coordinates: pointer, count: UInt(linecoords.count))
        
        shape.title = "fifth"
        
        self.polylines.append(shape)
        
        self.mapView.addAnnotation(shape)
        
    }
    
    func printSixth(index: Int) {
        
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
            
            self.firstHts.append(ht)
            
            let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
            
            linecoords.append(coordpoint)
            
        }
        let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: linecoords)
        let shape = MGLPolyline(coordinates: pointer, count: UInt(linecoords.count))
        
        shape.title = "sixth"
        
        self.polylines.append(shape)
        
        self.mapView.addAnnotation(shape)
        
    }
    
    func printSeventh(index: Int) {
        
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
            
            self.firstHts.append(ht)
            
            let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
            
            linecoords.append(coordpoint)
            
        }
        let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: linecoords)
        let shape = MGLPolyline(coordinates: pointer, count: UInt(linecoords.count))
        
        shape.title = "seventh"
        
        self.polylines.append(shape)
        
        self.mapView.addAnnotation(shape)
        
    }

    
//    func goPolylines() {
//
//        print("boner")
//
//        print(self.polylines)
//
//        let polypower = MGLMultiPolyline(polylines: self.polylines)
//
//        print(polypower)
//
//        self.mapView.addAnnotation(polypower)
//    }
    
    
    
    
    
    
    
    
    
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
            // Mapbox cyan
            return .green
        }
        if (annotation.title == "second" && annotation is MGLPolyline) {
            
            
            // Mapbox cyan
            return UIColor(red: 127.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        
        if (annotation.title == "third" && annotation is MGLPolyline) {
            // Mapbox cyan
             return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        
        if (annotation.title == "fourth" && annotation is MGLPolyline) {
            // Mapbox cyan
            return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        if (annotation.title == "fifth" && annotation is MGLPolyline) {
            // Mapbox cyan
            return UIColor(red: 255.0/255.0, green: 170.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        
        if (annotation.title == "sixth" && annotation is MGLPolyline) {
            // Mapbox cyan
            return UIColor(red: 225.0/255.0, green: 85.0/255.0, blue: 120.0/255.0, alpha: 1)
        }
            
        if (annotation.title == "seventh" && annotation is MGLPolyline) {
            
            return UIColor(red: 255.0/255.0, green: 0.0/255, blue: 0.0/255.0, alpha: 1)
            // Mapbox cya
//            return UIColor(red: 255.0, green: 255.0, blue: 120.0, alpha: 1)
        }
            
        if (annotation.title == "shortest" && annotation is MGLPolyline) {
            
            
            return .red
        }

        else
        {
            return .brown
        }
        


    }
    
    

    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
    
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 6000, pitch: 60, heading: 230)
        
        // Animate the camera movement over 5 seconds.
        mapView.setCamera(camera, withDuration: 5, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    }
    
//    
//    func mapView(mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
//        // Set the alpha for all shape annotations to 1 (full opacity)
//        return 1
//    }
//    
//    func mapView(mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
//        // Set the line width for polyline annotations
//        return 5.0
//    }
//    
//    func mapView(mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
//        // Give our polyline a unique color by checking for its `title` property
//        return UIColor.red
//    }
//    
    
    
}
