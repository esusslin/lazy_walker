//
//  ViewController.swift
//  LazyWalker
//
//  Created by Emmet Susslin on 2/9/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

// jared API: 372a9f91-e653-4793-a4e8-fb33663697db
//google places API: AIzaSyDMwIMkdZJIpz9Q6qJPI_E6SvAVLen9dEg


import UIKit
import CoreLocation
import CoreData
import Mapbox
import Alamofire
import Charts
import SwiftCharts
import GooglePlaces


//// GLOBALS

let locationManager = CLLocationManager()

var latitude = Double()
var longitude = Double()

var destination = CLLocationCoordinate2D()
var origin = CLLocationCoordinate2D()
var destinationDirection = Double()

// FOR ALL ROUTES
var paths = [[String:Any]]()

// UNIQUE VALUES OF EACH ROUTE

var ascend = [Double]()
var descend = [Double]()
var totalDistance = [Double]()

var totalDistanceOverall = Double()

// ALL COORDINATES

var firstCoords = [NSArray]()
var secondCoords = [NSArray]()
var thirdCoords = [NSArray]()
var fourthCoords = [NSArray]()
var fifthCoords = [NSArray]()

var pointArr : [(Double, Double)] = []


class mapVC: UIViewController, MGLMapViewDelegate, CAAnimationDelegate, UISearchBarDelegate, UITableViewDelegate {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?


    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var logoImageview: UIImageView!
    @IBOutlet weak var mapView: MGLMapView!
    

    @IBOutlet weak var searchBtn: UIButton!

    

//    var mySearchBar: UISearchBar!
    @IBOutlet weak var mySearchBar: UISearchBar!
    var placesClient: GMSPlacesClient!
    

    var mask: CALayer!
    var animation: CABasicAnimation!
    
    var customView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        
        let currentLocation = locationManager.location
        
        latitude = (currentLocation?.coordinate.latitude)!
        longitude = (currentLocation?.coordinate.longitude)!
        
        let corner1 = CLLocationCoordinate2D(latitude: latitude + 1, longitude: longitude + 1)
        let corner2 = CLLocationCoordinate2D(latitude: latitude - 1, longitude: longitude - 1)
        
        let bounds = GMSCoordinateBounds(coordinate: corner1, coordinate: corner2)
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        resultsViewController?.autocompleteBounds = bounds
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        //        searchController.
        searchController?.searchResultsUpdater = resultsViewController

//        resultsViewController?.tableCellBackgroundColor = UIColor(white: 1, alpha: 0.01)
        resultsViewController?.tableCellBackgroundColor = .black
        resultsViewController?.primaryTextHighlightColor = .white
        resultsViewController?.primaryTextColor = .gray
        resultsViewController?.secondaryTextColor = .gray
        resultsViewController?.tableCellSeparatorColor = .gray
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        
        // Add the search bar to the right of the nav bar,
        // use a popover to display the results.
        // Set an explicit size as we don't want to use the entire nav bar.
        searchController?.searchBar.frame = (CGRect(x: 0, y: 0, width: screenSize.width - 30, height: 44.0))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: (searchController?.searchBar)!)
        //        searchController?.searchBar.layer.borderColor = UIColor.white.cgColor
        //        searchController?.searchBar.layer.shadowOpacity = 0.5
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Keep the navigation bar visible.
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.modalPresentationStyle = .popover

        
        print(latitude)
        print(longitude)
        
        
        // HERE WE GO
        animateLaunch(image: UIImage(named: "people1")!)

        //SEARCHBARVIEW
        


        
        // map stuff
        
        // Set the map view‘s delegate property
        mapView.delegate = self
        
        mapView.frame = view.bounds
//        mapView.styleURL = URL(string: "mapbox://styles/esusslin/cixvherpa00032smn8c7kffjp")
        
        mapView.styleURL = URL(string: "mapbox://styles/mapbox/dark-v9")
        
//        mapView.styleURL = URL(string: "mapbox://styles/mapbox/dark")
        
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
        
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: (latitude), longitude: (longitude)), zoomLevel: 13, animated: false)
        
//        destination = CLLocationCoordinate2D(latitude: 37.793591, longitude: -122.440243)
        
        
        origin = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        totalDistanceOverall = self.distance(origin, destination)


        
//        bearingToLocationDegrees(destinationLocation:CLLocation(latitude: 37.793591, longitude: -122.440243))
        
//        getGraphopper()
    }
    
    

    
    func addGraphicSubview(index: String) {
        
        let num = Int(index)!
        
        var pointsAry = [NSArray]()
        var color = UIColor()
        
        if num == 0 {
            pointsAry = firstCoords
            color = .green
        }
        
        if num == 1 {
            pointsAry = secondCoords
            color = UIColor(red: 127.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        
        if num == 2 {
            pointsAry = thirdCoords
            color = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        
        if num == 3 {
            pointsAry = fourthCoords
            color = UIColor(red: 255.0/255.0, green: 150.0/255.0, blue: 0.0/255.0, alpha: 1)
        }

        if num == 4 {
            pointsAry = fifthCoords
            color = .red
        }
        
        
        
        for point in pointsAry {
            let dot = (point[0] as! Double, point[1] as! Double)
            pointArr.append(dot as! (Double, Double))
        }
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        
        customView.frame = CGRect.init(x: 0, y: height - 200, width: screenSize.width - 30, height: 85)
        
        customView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        customView.center.x = self.view.center.x
        customView.layer.cornerRadius = customView.frame.size.width / 16
        

        let sortedAscend = ascend.sorted()
        
        let chartConfig = ChartConfigXY(
            xAxisConfig: ChartAxisConfig(from: 0, to: totalDistanceOverall as! Double, by: 2),
            yAxisConfig: ChartAxisConfig(from: 0, to: sortedAscend[sortedAscend.count - 1] + 100, by: 2)
        )
        
//        let chartdata = LineChartDataSet
        
        let chart = LineChart(
            frame: CGRect.init(x: 0, y: 50, width: screenSize.width - 35, height: 80),
            chartConfig: chartConfig,
            xTitle: "X axis",
            yTitle: "Y axis",
            lines: [
                (chartPoints: pointArr, color: color),
//                (chartPoints: [(2.0, 2.6), (4.2, 4.1), (7.3, 1.0), (8.1, 11.5), (14.0, 3.0)], color: .blue)
            ]
        )
        
        
        
        self.customView.addSubview(chart.view)
        
//        chart.view.center = customView.center
        
        self.view.addSubview(customView)
    }
    


    func getGraphopper(destination: CLLocationCoordinate2D) {
        
        let destiny = destination
        
        let destLat = destiny.latitude
        let destLong = destiny.longitude

        let originString = "\(latitude)," + "\(longitude)"
        
        let deString = "\(destLat)," + "\(destLong)"
        
        let pointstring = originString + "&point=" + deString
        
        let theString = "https://graphhopper.com/api/1/route?point=" + pointstring + "&vehicle=foot&locale=en&elevation=true&points_encoded=false&ch.disable=true&heading=1&algorithm=alternative_route&alternative_route.max_paths=20&alternative_route.max_weight_factor=4&alternative_route.max_share_factor=2&key=a67e19cf-291b-492b-b380-68405b49e910"
//        
        print(theString)
        
        
        Alamofire.request(theString).responseJSON { response in
        
            
            if let JSON = response.result.value as? [String:Any] {
                
             self.adjustCameraForRoutes()
                
                print(response)
                
                let pathss = JSON["paths"] as! [[String:Any]]
                
                print("path options:")
                print(paths.count)
                
                for path in pathss {
                    
                    let points = path["points"] as? [String:Any]
                    let coords = points?["coordinates"] as! NSArray!
                   
                    var elevations = [Double]()
                    
                    ascend.append((path["ascend"] as? Double)!)
                    descend.append((path["descend"] as? Double)!)
                    totalDistance.append((path["distance"] as? Double)!)
                    
//                    print((path["descend"] as? Double)!)

                
                
                paths.append(path)
                }
                
                self.flattestRoute()
                
            }
            
            }
        }

    
    func flattestRoute() {

        let sortedAscend = ascend.sorted()
    
        if (paths.count > 4) {
        let fiveflattest = ascend.index(of: sortedAscend[4])!
            printLine(index: fiveflattest, id: "4")
            }
        
        //FOURTH:
        if (paths.count > 4) {

        let fourflattest = ascend.index(of: sortedAscend[3])!
        printLine(index: fourflattest, id: "3")
        }

        //THIRD:
        let threeflattest = ascend.index(of: sortedAscend[2])!
        printLine(index: threeflattest, id: "2")
        
        //SECOND:
        let twoflattest = ascend.index(of: sortedAscend[1])!
        printLine(index: twoflattest, id: "1")
        
        // FIRST:
        let flattest = ascend.index(of: sortedAscend[0])!
        printLine(index: flattest, id: "0")

    }
    
    
    // PRINT FLATTEST ROUTES!

    
    func printLine(index: Int, id: String) {
        
        let path = paths[index]

        let points = path["points"]! as! AnyObject!
                let coords = points?["coordinates"] as! NSArray!
        
                    self.distanceElevation(points: coords!, id: id)

                            var linecoords = [CLLocationCoordinate2D]()
                            for coord in coords! {
        
                                let coordAry = coord as! NSArray
                                let lat = coordAry[1]
                                let lng = coordAry[0]
                                
                                let ht = coordAry[2]
                                
                                let point = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: lng as! CLLocationDegrees)
                                
                                
                                
                                add(coordinate: point, id: id)
                                
                                let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
                                
                                linecoords.append(coordpoint)
                                
                            }
        
                    totalDistanceOverall = self.distance(linecoords.first!, linecoords.last!)

        
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
    
    
    
    
    /// BOLD LINE
    
    func boldline(title: String) {
        
        let num = Int(title)!
        
        let sortedAscend = ascend.sorted()
        
        let index = ascend.index(of: sortedAscend[num])!
        
        let theindex = sortedAscend.index(of: ascend[index])!
        
        print("INDEX:")
        print(index)
        
        let path = paths[index]

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
    
    
    
    
    //// MAP STUFF
    
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
    
    
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> UIView? {
        // Only show callouts for `Hello world!` annotation
        
        self.addGraphicSubview(index: annotation.title!!)
        return CustomCalloutView(representedObject: annotation)
        
    }
    
    
    func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        
       
        
        if (annotation.title! != nil) {
            
            let title = annotation.title!
            boldline(title: title!)
            
            let num = Int(title!)!
            
            let sortedAscend = ascend.sorted()
            
            let index = ascend.index(of: sortedAscend[num])!

            
            // Callout height is fixed; width expands to fit its content.
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
            label.textAlignment = .right
            label.textColor = UIColor(red: 0.81, green: 0.71, blue: 0.23, alpha: 1)
            label.text = "\(sortedAscend[num])" + " uphill climb"
            return label
        }
        
        return nil
    }

    
    
    
    ///// ANNOTATION PARTICULARS
    
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
        
        pointArr.removeAll()
        
        for v in self.customView.subviews{
            
                v.removeFromSuperview()
            
        }
        
        self.customView.removeFromSuperview()
        
        
        
        let poly = mapView.annotations?.filter { annotation in
            
            return (annotation.title??.localizedCaseInsensitiveContains("BOLD") == true)
            
        }
        
        if (poly!.count > 0) {
        
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

        
        if (name == "2BOLD") {
            let shape = first as! MGLPolyline
            shape.title = "2"
            
            print(shape.title)
            self.mapView.addAnnotation(shape)
        }

        
        if (name == "1BOLD") {
            let shape = first as! MGLPolyline
            shape.title = "1"
            
            print(shape.title)
            self.mapView.addAnnotation(shape)
        }

        
        if (name == "0BOLD") {
            let shape = first as! MGLPolyline
            shape.title = "0"
            
            print(shape.title)
            self.mapView.addAnnotation(shape)
        }
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
        
        let lat1 = DegreesToRadians(degrees: latitude)
        let lon1 = DegreesToRadians(degrees: longitude)
        
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
        
        destinationDirection = degrees!
        
        return heading
    }
    
    ///// TABLEVIEW STUFF

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    ////////////////////
    
    
    // MAP CAMERA

//    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
    
    func adjustCameraForRoutes() {
    
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: totalDistanceOverall*1.7, pitch: 60, heading: (destinationDirection))
        
        print("TOTAL DISTANCE")
        print(totalDistanceOverall)
        
        // Animate the camera movement over 5 seconds.
        mapView.setCamera(camera, withDuration: 3, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    }
    
    
    
    // ANIMATIONS:
    
    func animateLaunch(image: UIImage) {
        
        //        self.view.backgroundColor = bgColor
        
        // Create and apply mask
        
        mask = CALayer()
        mask.contents = image.cgImage
        mask.bounds = CGRect(x: 0, y: 0, width: 128, height: 128)
        mask.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        mask.position = CGPoint(x: mapView.frame.width / 2.0, y: mapView.frame.height / 2.0)
        mapView.layer.mask = mask
        
        animateDecreaseSize()
        
    }
    
    func animateDecreaseSize() {
        
        let decreaseSize = CABasicAnimation(keyPath: "bounds")
        decreaseSize.delegate = self
        decreaseSize.duration = 2.0
        decreaseSize.fromValue = NSValue(cgRect: mask!.bounds)
        decreaseSize.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: 20, height: 20))
        
        decreaseSize.fillMode = kCAFillModeForwards
        decreaseSize.isRemovedOnCompletion = false
        
        mask.add(decreaseSize, forKey: "bounds")
        
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animateIncreaseSize()
    }
    
    func animateIncreaseSize() {
        
        animation = CABasicAnimation(keyPath: "bounds")
        animation.duration = 2.0
        animation.fromValue = NSValue(cgRect: mask!.bounds)
        animation.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: 8000, height: 8000))
        
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        
        mask.add(animation, forKey: "bounds")
        
        // Fade out overlay
//        UIView.animate(withDuration: 2.0, animations: { () -> Void in
//            self.overlay.alpha = 0
//            self.logoImageview.alpha = 0
//            print("boner?")
//            
//        })
        
        UIView.animate(withDuration: 2.0, animations: { 
            self.overlay.alpha = 0
            self.logoImageview.alpha = 0
        }) { (true) in
//            self.searchBarShow()
        }
        
        
    }
    
    
    // PRIVATE FUNCTIONS:
    
    
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
            
            let point = [distanceCounter, htAry[index]] as! NSArray
            
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
    
    
//        let fromLoc = CLLocation(latitude: from.latitude, longitude: from.longitude)
//        let toLoc = CLLocation(latitude: to.latitude, longitude: to.longitude)
//        return fromLoc.distance(from: toLoc)
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






// Handle the user's selection.
extension mapVC: GMSAutocompleteResultsViewControllerDelegate {
    
    
    
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        
        
        searchController?.isActive = false
        
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        let lat = place.coordinate.latitude
        let lon = place.coordinate.longitude
        
        
        destination = CLLocationCoordinate2D(latitude: lat, longitude: lon)
//        self.bearingToLocationDegrees(destinationLocation:destination)
        
        bearingToLocationDegrees(destinationLocation:CLLocation(latitude: lat, longitude: lon))
        
        
        
        totalDistanceOverall = self.distance(origin, destination)
        self.getGraphopper(destination: destination)

    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}


