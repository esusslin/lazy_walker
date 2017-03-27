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


class mapVC: UIViewController, MGLMapViewDelegate, UISearchBarDelegate, UITableViewDelegate {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    
    
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var darkFillView: UIView!
    
    @IBOutlet weak var toggleMenuButton: UIButton!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    
    @IBOutlet weak var btn5: UIButton!


    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var logoImageview: UIImageView!
    @IBOutlet weak var mapView: MGLMapView!


    
    @IBOutlet weak var imageView: UIImageView!

//    var mySearchBar: UISearchBar!
   
    var placesClient: GMSPlacesClient!
    

    var mask: CALayer!
    var animation: CABasicAnimation!
    
    
    
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

        
        // Set the map view‘s delegate property
        mapView.delegate = self
        
        mapView.frame = view.bounds
       
        mapView.styleURL = URL(string: "mapbox://styles/mapbox/dark-v9")
    
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        mapView.setCenter(CLLocationCoordinate2D(latitude: (latitude), longitude: (longitude)), zoomLevel: 13, animated: false)
        

        origin = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        totalDistanceOverall = self.distance(origin, destination)

    }

    
    func reset() {
        
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
        
        
        if self.mapView.annotations != nil {
//            print("ANNOTATION COUNT:")
//            print(mapView.annotations?.count)
            self.mapView.removeAnnotations(self.mapView.annotations!)
        }

    }
    
    func setLocation() {
        
        
        
        let currentLocation = locationManager.location
        
        latitude = (currentLocation?.coordinate.latitude)!
        longitude = (currentLocation?.coordinate.longitude)!
        
        let corner1 = CLLocationCoordinate2D(latitude: latitude + 0.1, longitude: longitude + 0.1)
        let corner2 = CLLocationCoordinate2D(latitude: latitude - 0.1, longitude: longitude - 0.1)
        
        let bounds = GMSCoordinateBounds(coordinate: corner1, coordinate: corner2)
        
//        print(bounds)
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        resultsViewController?.autocompleteBounds = bounds
        
//        print(resultsViewController?.autocompleteBounds)

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
        print("annotation title")
        print(annotation.title!!)
        self.boldline(title: annotation.title!!)
        self.addAnnotationSubview(index: annotation.title!!)
        self.addGraphicSubview(index: annotation.title!!)
        return CustomCalloutView(representedObject: annotation)
        
    }
    
    
//    func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
//        
//       
//        
//        if (annotation.title! != nil) {
//            
//            let title = annotation.title!
//            boldline(title: title!)
//            
//            let num = Int(title!)!
//            
//            let sortedAscend = ascend.sorted()
//            
//            let index = ascend.index(of: sortedAscend[num])!
//
//            
//            // Callout height is fixed; width expands to fit its content.
//            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
//            label.textAlignment = .right
//            label.textColor = UIColor(red: 0.81, green: 0.71, blue: 0.23, alpha: 1)
//            label.text = "\(sortedAscend[num])" + " uphill climb"
//            return label
//        }
//        
//        return nil
//    }

    
    
    
    ///// ANNOTATION PARTICULARS
    
//    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
//        return UIButton(type: .detailDisclosure)
//    }
//    
//    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
//        // Hide the callout view.
//        mapView.deselectAnnotation(annotation, animated: false)
//        
//        UIAlertView(title: annotation.title!!, message: "A lovely (if touristy) place.", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
//    }
    
    
    
    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
        
        let catchtitle = String()
        
    
        removeSubview()
        removeBold()
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
            
            print("BOLD BONER!")
            
            return 12.0
        }
                else
        {

        return 4.0
        }
    
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        // Give our polyline a unique color by checking for its `title` property
        
        
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
    
    
    
    // MAP CAMERA

//    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
    
    func adjustCameraForRoutes() {
    
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: totalDistanceOverall*1.7, pitch: 60, heading: (destinationDirection))
        
        print("TOTAL DISTANCE")
        print(totalDistanceOverall)
        
        // Animate the camera movement over 5 seconds.
        mapView.setCamera(camera, withDuration: 3, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        
        self.imageShow()
    }
    
    
    
        func imageShow() {
    
            print("imageshow!")
    
            UIView.animate(withDuration: 6, animations: {
               self.imageView.alpha = 0.5
            }) { (true) in
                UIView.animate(withDuration: 6, animations: {
                    self.imageHide()
                }, completion: { (true) in
    
                })
            }
    
        }
    
    func imageHide() {
        
        print("imagehide!")
        
        UIView.animate(withDuration: 6, animations: {
            self.imageView.alpha = 0.0
        }) { (true) in
            UIView.animate(withDuration: 1, animations: {
                //                    self.customView.alpha = 1
            }, completion: { (true) in
                
            })
        }
        
    }
 }






// Handle the user's selection.
extension mapVC: GMSAutocompleteResultsViewControllerDelegate {

    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        
        self.darkFillView.transform = .identity
        self.menuView.transform = .identity
        self.toggleMenuButton.transform = .identity
        
        

        self.reset()
        self.setLocation()
        
        searchController?.isActive = false
        
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        print(place.placeID)
        
        self.loadFirstPhotoForPlace(placeID: place.placeID)
        
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

