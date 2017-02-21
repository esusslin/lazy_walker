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
        
        
    
        self.destination = CLLocationCoordinate2D(latitude: 37.759505, longitude: -122.432606)
        
       bearingToLocationDegrees(destinationLocation:CLLocation(latitude: 37.759505, longitude: -122.432606))
        
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
                    
                    print(coords?.count)
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

        let sortedAscend = self.ascend.sorted()
    
        if (self.paths.count > 4) {
        let fiveflattest = self.ascend.index(of: sortedAscend[4])!
            printLine(index: fiveflattest, id: "4")
            }
        
        //FOURTH:
        let fourflattest = self.ascend.index(of: sortedAscend[3])!
        printLine(index: fourflattest, id: "3")

        
        //THIRD:
        let threeflattest = self.ascend.index(of: sortedAscend[2])!
        printLine(index: threeflattest, id: "2")
            
       
        
        //SECOND:
        let twoflattest = self.ascend.index(of: sortedAscend[1])!
        printLine(index: twoflattest, id: "1")
        
        
        // FIRST:
        let flattest = self.ascend.index(of: sortedAscend[0])!
        printLine(index: flattest, id: "0")

    }
    
    
    // PRINT FLATTEST ROUTES!

    
    func printLine(index: Int, id: String) {
        
        let path = self.paths[index]

        let points = path["points"]! as! AnyObject!
                let coords = points?["coordinates"] as! NSArray!
                            var linecoords = [CLLocationCoordinate2D]()
                            for coord in coords! {
        
                                let coordAry = coord as! NSArray
                                let lat = coordAry[1]
                                let lng = coordAry[0]
                                let point = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: lng as! CLLocationDegrees)
                                
                                add(coordinate: point, id: id)
                                
                                let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
                                
                                linecoords.append(coordpoint)
                                
                            }
        
                    for (index, _) in linecoords.enumerated() {
                            if index == 0 { continue } // skip first
                            self.split(linecoords[index - 1], linecoords[index], id)
                    }

        
        
                    let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: linecoords)
                    let shape = MGLPolyline(coordinates: pointer, count: UInt(linecoords.count))
        
                    shape.title = id
        
                   self.mapView.addAnnotation(shape)
                   mapView.selectAnnotation(shape, animated: true)
    }
    
    
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        // Try to reuse the existing ‘pisa’ annotation image, if it exists.
        
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "dot")
        
        if annotationImage == nil {
            // Leaning Tower of Pisa by Stefan Spieler from the Noun Project.
            var image = UIImage(named: "dot")!

            image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/2, right: 0))
            
            
            // Initialize the ‘pisa’ annotation image with the UIImage we just loaded.
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "dot")
        }
        
        return annotationImage
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        if (annotation.title! != nil) {
            
                    let title = annotation.title!
            
                    boldline(title: title!)
            
            // Callout height is fixed; width expands to fit its content.
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
            label.textAlignment = .right
            label.textColor = UIColor(red: 0.81, green: 0.71, blue: 0.23, alpha: 1)
            label.text = "金閣寺"
            
            return label
        }
        
        return nil
    }
    

    
    func boldline(title: String) {
        
        let num = Int(title)!
        
        let sortedAscend = self.ascend.sorted()
        
        let index = self.ascend.index(of: sortedAscend[num])!
        
        let theindex = sortedAscend.index(of: ascend[index])!
        
        print("INDEX:")
        print(index)
        
        let path = self.paths[index]

//        print(num)
        
        
        
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
        
        if (theindex == 0) {
            shape.title = "0BOLD"
        }
        
        if (theindex == 1) {
            shape.title = "1BOLD"
        }
        
        if (theindex == 2) {
            shape.title = "2BOLD"
        }
        
        if (theindex == 3) {
            shape.title = "3BOLD"
        }
        
        if (theindex == 4) {
            shape.title = "4BOLD"
        }
        
        self.mapView.addAnnotation(shape)
        }

    
    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        return UIButton(type: .detailDisclosure)
    }
    
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        // Hide the callout view.
        mapView.deselectAnnotation(annotation, animated: false)
        
        UIAlertView(title: annotation.title!!, message: "A lovely (if touristy) place.", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
    }
    
    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
        
        let catchtitle = String()
        
        let poly = mapView.annotations?.filter { annotation in
            
            return (annotation.title??.localizedCaseInsensitiveContains("BOLD") == true)
            
        }
        
        let first = poly?.first!
        
        mapView.removeAnnotation(first!)
        
        let name = first!.title!
        
        if (name == "4BOLD") {
            let shape = first as! MGLPolyline
            shape.title = "4"
            
            print(shape.title)
            self.mapView.addAnnotation(shape)
        }
        
        if (name == "3BOLD") {
            let shape = first as! MGLPolyline
            shape.title = "3"
            
            print(shape.title)
            self.mapView.addAnnotation(shape)
        }

        
        if (name == "3BOLD") {
            let shape = first as! MGLPolyline
            shape.title = "2"
            
            print(shape.title)
            self.mapView.addAnnotation(shape)
        }

        
        if (name == "2BOLD") {
            let shape = first as! MGLPolyline
            shape.title = "1"
            
            print(shape.title)
            self.mapView.addAnnotation(shape)
        }

        
        if (name == "1BOLD") {
            let shape = first as! MGLPolyline
            shape.title = "0"
            
            print(shape.title)
            self.mapView.addAnnotation(shape)
        }

    }

    
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        // Set the alpha for all shape annotations to 1 (full opacity)
        return 1
    }
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        // Set the line width for polyline annotations
        print("ANNOTATION TITLE:")
        print(annotation.title!)
        
        if ((annotation.title!.localizedCaseInsensitiveContains("BOLD") == true) && annotation is MGLPolyline) {
            
            return 12.0
        }
                else
        {

        return 4.0
        }
    
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        // Give our polyline a unique color by checking for its `title` property
        
        
        if ((annotation.title == "0" || annotation.title == "0BOLD") && annotation is MGLPolyline) {

            return .green
        }
        if ((annotation.title == "1" || annotation.title == "1BOLD") && annotation is MGLPolyline) {

            return UIColor(red: 127.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        
        if ((annotation.title == "2" || annotation.title == "2BOLD") && annotation is MGLPolyline) {

             return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        
        if ((annotation.title == "3" || annotation.title == "3BOLD") && annotation is MGLPolyline) {

            return UIColor(red: 255.0/255.0, green: 150.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        
        if ((annotation.title == "4" || annotation.title == "4BOLD") && annotation is MGLPolyline) {

            return UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
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
    
    
    ////////////////////
    
    
    // MAP CAMERA

    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
    
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 6000, pitch: 60, heading: (self.destinationDirection))
        
        
        
        // Animate the camera movement over 5 seconds.
        mapView.setCamera(camera, withDuration: 5, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    }
    
    
    // PRIVATE FUNCTIONS:
    
    
    private func add(coordinate: CLLocationCoordinate2D, id: String) {
        DispatchQueue.main.async {
            // Unowned reference to self to prevent retain cycle
            
            
            [unowned self] in
            let point = MGLPointAnnotation()
            point.coordinate = coordinate
            point.title = id
            point.subtitle = "\(coordinate.latitude) / \(coordinate.longitude)"
            self.mapView.addAnnotation(point)
        }
    }
    
    private func split(_ from: CLLocationCoordinate2D, _ to: CLLocationCoordinate2D, _ id: String) {
        
        print("BONER!")
        if distance(from, to) > 40 { // THRESHOLD is 200m
            let middle = mid(from, to)
            add(coordinate: middle, id: id)
            split(from, middle, id)
            split(middle, to, id)
        }
        
        add(coordinate: from, id: id)
        add(coordinate: to, id: id)
    }
    
    private func distance(_ from: CLLocationCoordinate2D, _ to: CLLocationCoordinate2D) -> Double {
        let fromLoc = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLoc = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLoc.distance(from: toLoc)
    }
    
    private func mid(_ from: CLLocationCoordinate2D, _ to: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let latitude = (from.latitude + to.latitude) / 2
        let longitude = (from.longitude + to.longitude) / 2
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    
}

