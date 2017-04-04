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


class mapVC: UIViewController, MGLMapViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    

    
    
    // MENU PIECES
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var darkFillView: UIView!
    @IBOutlet weak var toggleMenuButton: UIButton!
    
    //MAP BUTTONS
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var centerMapBtn: UIButton!
    @IBOutlet weak var goBTn: UIButton!
    
    
    
    // DIRECTION TABLE PIECES
    
    @IBOutlet weak var tableDarkView: UIView!
    @IBOutlet weak var tableToggleButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var directionSubview: UIView!
  
    @IBOutlet weak var nextSubview: UIView!
    @IBOutlet weak var nextLbl: UILabel!


    @IBOutlet weak var distLbl: UILabel!
    @IBOutlet weak var arrowPic: UIImageView!

    
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    
    @IBOutlet weak var btn5: UIButton!


    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var logoImageview: UIImageView!
    @IBOutlet weak var mapView: MGLMapView!


    
    @IBOutlet weak var imageView: UIImageView!
   
    var placesClient: GMSPlacesClient!
    

    var mask: CALayer!
    var animation: CABasicAnimation!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let screenSize: CGRect = UIScreen.main.bounds
        
        menuView.center.x = screenSize.width / 2
        
        menuView.center.y = screenSize.height
        
        print(screenSize.width)
        
        darkFillView.layer.cornerRadius = 22.0
        
        btn1.layer.cornerRadius = 22.0
        btn2.layer.cornerRadius = 22.0
        btn3.layer.cornerRadius = 22.0
        btn4.layer.cornerRadius = 22.0
        btn5.layer.cornerRadius = 22.0
        
        cancelBtn.alpha = 0
        centerMapBtn.alpha = 0
        goBTn.alpha = 0
                
        btn1.backgroundColor = .green
        btn2.backgroundColor = UIColor(red: 127.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1)
        btn3.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1)
        btn4.backgroundColor = UIColor(red: 255.0/255.0, green: 150.0/255.0, blue: 0.0/255.0, alpha: 1)
        btn5.backgroundColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
        
        btn1.layer.borderWidth = 4.0
        btn2.layer.borderWidth = 4.0
        btn3.layer.borderWidth = 4.0
        btn4.layer.borderWidth = 4.0
        btn5.layer.borderWidth = 4.0
        
        btn1.layer.borderColor = UIColor.white.cgColor
        btn2.layer.borderColor = UIColor.white.cgColor
        btn3.layer.borderColor = UIColor.white.cgColor
        btn4.layer.borderColor = UIColor.white.cgColor
        btn5.layer.borderColor = UIColor.white.cgColor
        
        btn1.layer.shadowRadius = 5
        btn1.layer.shadowOpacity = 0.8
        btn1.layer.shadowOffset = CGSize(width: 5, height: 5)

                
        btn5.alpha = 0
        btn4.alpha = 0
        btn3.alpha = 0
        btn2.alpha = 0
        btn1.alpha = 0
        menuView.alpha = 0
        
        btn1.translatesAutoresizingMaskIntoConstraints = false
        btn2.translatesAutoresizingMaskIntoConstraints = false
        btn3.translatesAutoresizingMaskIntoConstraints = false
        btn4.translatesAutoresizingMaskIntoConstraints = false
        btn5.translatesAutoresizingMaskIntoConstraints = false
        
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 2
        
        tap.addTarget(self, action: Selector("toDirections"))
        btn1.addGestureRecognizer(tap)
        btn2.addGestureRecognizer(tap)
        btn3.addGestureRecognizer(tap)
        btn4.addGestureRecognizer(tap)
        btn5.addGestureRecognizer(tap)

        //TABLE POSITIONING
        tableView.backgroundColor = .black
        tableView.backgroundView?.alpha = 0.5
        tableView.frame.size.height = screenSize.height
        tableView.center.y = view.center.y + 500
        
        tableDarkView.center.y = tableView.center.y - 360
        tableToggleButton.center.y = tableView.center.y - 360
        tableDarkView.layer.cornerRadius = 22.0
        
        // INITIALLY HIDDEN
        tableView.alpha = 0
        tableDarkView.alpha = 0
        tableToggleButton.alpha = 0
        directionSubview.alpha = 0
        
        nextSubview.alpha = 0

        
        reset()
        
        setLocation()
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController

        resultsViewController?.tableCellBackgroundColor = .black
        resultsViewController?.primaryTextHighlightColor = .white
        resultsViewController?.primaryTextColor = .gray
        resultsViewController?.secondaryTextColor = .gray
        resultsViewController?.tableCellSeparatorColor = .gray
        
        
        
        imageView.alpha = 0
        imageView.frame = CGRect.init(x: 0, y: 100, width: screenSize.width - 60, height: screenSize.height / 6)
        imageView.center.x = self.view.center.x
        imageView.center.y = self.view.center.y / 2.5
        
        
        
        // Add the search bar to the right of the nav bar,
        // use a popover to display the results.
        // Set an explicit size as we don't want to use the entire nav bar.
        searchController?.searchBar.frame = (CGRect(x: 0, y: 0, width: screenSize.width - 30, height: 44.0))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: (searchController?.searchBar)!)

        definesPresentationContext = true
        
        // Keep the navigation bar visible.
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.modalPresentationStyle = .popover

        
        print(latitude)
        print(longitude)
        
        
        // HERE WE GO
        animateLaunch(image: UIImage(named: "people1")!)

        
        // SET TEH MAP'S VIEW AND DELEGATE PROPERTY
        mapView.delegate = self
        mapView.frame = view.bounds
        mapView.styleURL = URL(string: "mapbox://styles/mapbox/dark-v9")
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: (latitude), longitude: (longitude)), zoomLevel: 13, animated: false)
        

        origin = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        totalDistanceOverall = self.distance(origin, destination)

    }
    

    
    func reset() {
        
        // ALL INTERNAL STORAGE ARRAYS ARE CLEARED 
        
        // FOR ALL ROUTES
        paths.removeAll()
        
        // UNIQUE VALUES OF EACH ROUTE
        ascend.removeAll()
        descend.removeAll()
        totalDistance.removeAll()
        
        totalDistanceOverall = 0.0
        
        // ALL COORDINATES
        firstCoords.removeAll()
        secondCoords.removeAll()
        thirdCoords.removeAll()
        fourthCoords.removeAll()
        fifthCoords.removeAll()
        
        
        // MAP IS CLEARED OF ANNOTATIONS:
        
        if self.mapView.annotations != nil {

            self.mapView.removeAnnotations(self.mapView.annotations!)
        }
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: (latitude), longitude: (longitude)), zoomLevel: 13, animated: false)

    }
    
    
    // SUBVIEWS FADE FROM VIEW GRADUALLY
    
    func fadeOutSubviews() {
        UIView.animate(withDuration: 1.2, animations: {
            self.cancelBtn.alpha = 0
            self.centerMapBtn.alpha = 0
            self.directionSubview.alpha = 0
            self.tableView.alpha = 0
            self.toggleMenuButton.alpha = 0
            self.tableDarkView.alpha = 0
            
        }) { (true) in
            self.resetCamera()
        }
        
    }
    

    
    // SETS CURRENT LOCATION

    func setLocation() {
        
        let currentLocation = locationManager.location
        
        latitude = (currentLocation?.coordinate.latitude)!
        longitude = (currentLocation?.coordinate.longitude)!
        
        
        // ESTABLISHES BOUNDS FOR GOOGLE-PLACES SEARCH
        let corner1 = CLLocationCoordinate2D(latitude: latitude + 0.1, longitude: longitude + 0.1)
        let corner2 = CLLocationCoordinate2D(latitude: latitude - 0.1, longitude: longitude - 0.1)

        let bounds = GMSCoordinateBounds(coordinate: corner1, coordinate: corner2)
   
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        resultsViewController?.autocompleteBounds = bounds

    }
    
    
    // MAP BUTTONS
    
    // RESETS THE APP
    @IBAction func cancelBtnPressed(_ sender: Any) {
    
        reset()
    }
    
     // RESETS THE MAPVIEW TO DIRECTIONS VIEW (IN CASE OF SCROLLING OFF, ETC)
    @IBAction func centerMap(_ sender: Any) {
        
        adjustCameraForDirections()
    }
    
    
    // GOES FROM TABLE VIEW OF DIRECTIONS TO LIVE DIRECTIONS
    
    @IBAction func goBtnPressed(_ sender: Any) {
        
        geoStart()
    }
    
    
    
    // MAPVIEW PROTOCOLS:
    
    
    
    // MAPVIEW PROTOCOL FOR POINT ANNOTATIONS (MAKES POLYLINES TAP-ABLE)
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "dot")
        
        if annotationImage == nil {
            var image = UIImage(named: "dot")!
            image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/2, right: 0))

            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "dot")
        }
        
        return annotationImage
    }
    
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    
    // WHEN ANNOTATION POINTS ARE TAPPED THE ANNOTATION VIEW IS PRESENTED AS WELL AS
    //...A GRAPHIC SUBVIEW OF THE ROUTE FOR THE USER TO EVALUATE
    
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> UIView? {

        self.boldline(title: annotation.title!!)
        self.addAnnotationSubview(index: annotation.title!!)
        self.addGraphicSubview(index: annotation.title!!)
        return CustomCalloutView(representedObject: annotation)
        
    }
 
    
    // IF THE USER DESELECTS A PATH (TAPS ELSEWHERE) THE SUBVIEWS DISAPPEAR AND BOLD LINES ARE RESTORED TO NORMAL SIZE
    
    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
        
        let catchtitle = String()
        
        removeSubview()
        removeBold()
    }

    
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return 1
    }
    
    
    // LINE FOR THE POLYLINES IS ESTABLISHED.  IF THE TITLE OF THE LINE INCLUDES 'BOLD' THEN THE LINE WILL APPEAR 3X THE WIDTH
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        
        if ((annotation.title!.localizedCaseInsensitiveContains("BOLD") == true) && annotation is MGLPolyline) {
            
            return 12.0
        }
                else
        {

        return 4.0
        }
    
    }
    
    // THE COLOR OF EACH LINE IS APPLIED.
    //THE FLATTEST ROUTE WILL BE GREEN AND THE MORE CHALLENGING ROUTES PROGRESSIVELY MORE RED
    // UICOLOR IS USED TO ACHIEVE THIS SPECTRUM:
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        
        
        if ((annotation.title == "0REG" || annotation.title == "0BOLD") && annotation is MGLPolyline) {

            return .green
        }
        if ((annotation.title == "1REG" || annotation.title == "1BOLD") && annotation is MGLPolyline) {

            return UIColor(red: 127.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        
        if ((annotation.title == "2REG" || annotation.title == "2BOLD") && annotation is MGLPolyline) {

             return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        
        if ((annotation.title == "3REG" || annotation.title == "3BOLD") && annotation is MGLPolyline) {

            return UIColor(red: 255.0/255.0, green: 150.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        
        if ((annotation.title == "4REG" || annotation.title == "4BOLD") && annotation is MGLPolyline) {

            return UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        else
        {
            return .brown
        }

    }
    
    
    
    // DIRECTIONAL BEARING:
    
    // THESE 2 FUNCITONS QUICKLY CONVERT DEGREES TO RADIANS AND VICE-VERSA
    
    func DegreesToRadians(degrees: Double ) -> Double {
        return degrees * M_PI / 180
    }
    
    func RadiansToDegrees(radians: Double) -> Double {
        return radians * 180 / M_PI
    }
    
    
    // MAP CAMERA ANIMATIONS:
    
    func resetCamera() {
        
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 13, pitch: 90, heading: (destinationDirection))

        // ANIMATES THE CAMERA OVER 5 SECONDS FOR DRAMATIC AWESOMENESS
        mapView.setCamera(camera, withDuration: 3, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        
        
    }

    // ONCE THE DESTINATION IS ENTERED THE CAMERA IS ADJUSTED TO A VIEW THAT WILL INCLUDE THE DESTINATION AND ALL OF THE POSSIBLE ROUTES FOR THE USER'S EVALUATION

    func adjustCameraForRoutes() {
    
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: totalDistanceOverall*1.7, pitch: 60, heading: (destinationDirection))

            mapView.setCamera(camera, withDuration: 3, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        
        self.imageShow()
    }
    
    
        // TO ENHANCE THE USER EXPERIENCE, IF AN IMAGE IS AVAILABLE VIA THE GOOGLE-PLACES CALL.. 
    
        // THE IMAGE WILL MAGICALLY APPEAR IN THE SKY ABOVE THE MAP...
        func imageShow() {
            
            UIView.animate(withDuration: 6, animations: {
               self.imageView.alpha = 0.5
            }) { (true) in
                UIView.animate(withDuration: 6, animations: {
                    self.imageHide()
                }, completion: { (true) in
    
                })
            }
    
        }
    
    // ..AND QUICKLY DISAPPEAR THEREAFTER..
    func imageHide() {
        
        UIView.animate(withDuration: 6, animations: {
            self.imageView.alpha = 0.0
        }) { (true) in
            UIView.animate(withDuration: 1, animations: {
                
            }, completion: { (true) in
                
            })
        }
        
    }
 }



// THIS EXTENSION HANDLES THE USER'S SELECTION VIA THE GOOGLE-PLACES API

// Handle the user's selection.
extension mapVC: GMSAutocompleteResultsViewControllerDelegate {

    
    // ONCE A PLACE IS SELECTED IT IS RECOGNIZED AS THE CURRENT DESTINATION
    
    
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        
        
        
        self.darkFillView.transform = .identity
        self.menuView.transform = .identity
        self.toggleMenuButton.transform = .identity

        self.reset()
        self.setLocation()
        
        searchController?.isActive = false
        
        // IF A GOOGLE-IMAGE IS AVAILABLE FOR THE DESTINATION THIS IS ACCESSED AND USED
        self.loadFirstPhotoForPlace(placeID: place.placeID)

        
        let lat = place.coordinate.latitude
        let lon = place.coordinate.longitude
        destination = CLLocationCoordinate2D(latitude: lat, longitude: lon)

        // THE DIRECTION FROM ORIGIN TO DESTINATION IS ACHIEVED AND USED TO ANGLE THE MAP FOR THE USER
        bearingToLocationDegrees(destinationLocation:CLLocation(latitude: lat, longitude: lon))

        // TOTAL DISTANCE OVERALL IS ACHIEVED
        totalDistanceOverall = self.distance(origin, destination)
        
        // DESTINATION COORDINATES & THE USER'S CURRENT LOCATION ARE USED IN THE API CALL TO GRAPHOPPER:
        
        self.getGraphopper(destination: destination)

    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        
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

