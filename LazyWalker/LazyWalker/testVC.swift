//
//  testVC.swift
//  LazyWalker
//
//  Created by Emmet Susslin on 3/9/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

import UIKit
import GooglePlaces





class testVC: UIViewController {
    

    @IBOutlet weak var menuView: UIView!

    @IBOutlet weak var darkFillView: UIView!
    
    @IBOutlet weak var toggleMenuButton: UIButton!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    
    @IBOutlet weak var btn5: UIButton!
    
    
    
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
        btn5.alpha = 0
        btn4.alpha = 0
        btn3.alpha = 0
        
        btn1.translatesAutoresizingMaskIntoConstraints = false
        btn2.translatesAutoresizingMaskIntoConstraints = false

        btn3.translatesAutoresizingMaskIntoConstraints = false

        btn4.translatesAutoresizingMaskIntoConstraints = false

        btn5.translatesAutoresizingMaskIntoConstraints = false


        position2()
        
        // Create the views dictionary
       let viewsDictionary = ["btn1":btn1, "btn2":btn2, "btn3":btn3, "btn4":btn4, "btn5":btn5]
        

        
        menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[btn1(44)]-18-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: viewsDictionary))
        
        menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[btn2(44)]-18-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: viewsDictionary))
        
        menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[btn3(44)]-18-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: viewsDictionary))
        
        menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[btn4(44)]-18-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: viewsDictionary))
        
        menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[btn5(44)]-18-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: viewsDictionary))

    }
    
    func position2() {
        
        let viewsDictionary = ["btn1":btn1, "btn2":btn2, "btn3":btn3, "btn4":btn4, "btn5":btn5]
        
        //         Create and add the vertical constraints
        menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-100-[btn1(44)]-80-[btn2(44)]-100-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: viewsDictionary))
    }

    
    
    
    func position3() {
        
        let viewsDictionary = ["btn1":btn1, "btn2":btn2, "btn3":btn3, "btn4":btn4, "btn5":btn5]
        
        //         Create and add the vertical constraints
        menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-70-[btn1(44)]-51-[btn2(44)]-51-[btn3(44)]-70-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: viewsDictionary))
    }
    
    func position4() {
        
         let viewsDictionary = ["btn1":btn1, "btn2":btn2, "btn3":btn3, "btn4":btn4, "btn5":btn5]
        
        //         Create and add the vertical constraints
        menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-54-[btn1(44)]-30-[btn2(44)]-30-[btn3(44)]-30-[btn4(44)]-54-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: viewsDictionary))
    }
    
    func position5() {
        
        
         let viewsDictionary = ["btn1":btn1, "btn2":btn2, "btn3":btn3, "btn4":btn4, "btn5":btn5]
        
        //         Create and add the vertical constraints
        menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[btn1(44)]-20-[btn2(44)]-20-[btn3(44)]-20-[btn4(44)]-20-[btn5(44)]-40-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: viewsDictionary))
    }
    

    @IBAction func toggleMenu(_ sender: UIButton) {
        
        if darkFillView.transform == CGAffineTransform.identity{
        
        UIView.animate(withDuration: 0.2, animations: {
            self.darkFillView.transform = CGAffineTransform(scaleX: 11, y: 11)
            self.menuView.transform = CGAffineTransform(translationX: 0, y: -60)
        }) { (true) in
            self.toggleMenuButton.transform = CGAffineTransform(rotationAngle: self.radians(degrees: 180.0))
        }
        } else {
            UIView.animate(withDuration: 0.2, animations: {
            self.darkFillView.transform = .identity
                self.menuView.transform = .identity
                self.toggleMenuButton.transform = .identity
            }) { (true) in
                
            }
        }
    }

    func radians(degrees: Double) -> CGFloat {
        return CGFloat(degrees * .pi / degrees)
    }

    

    
    
 }
    
    
//    func loadFirstPhotoForPlace(placeID: String) {
//        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
//            if let error = error {
//                // TODO: handle the error.
//                print("Error: \(error.localizedDescription)")
//            } else {
//                if let firstPhoto = photos?.results.first {
//                    self.loadImageForMetadata(photoMetadata: firstPhoto)
//                }
//            }
//        }
//    }
//    
//    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
//        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
//            (photo, error) -> Void in
//            if let error = error {
//                // TODO: handle the error.
//                print("Error: \(error.localizedDescription)")
//            } else {
//                self.imageView.image = photo;
//                self.attributionTextView.attributedText = photoMetadata.attributions;
//            }
//        })
//    }
    
//    var resultsViewController: GMSAutocompleteResultsViewController?
//    var searchController: UISearchController?
//    var resultView: UITextView?
//   
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let currentLocation = locationManager.location
//        
//        latitude = (currentLocation?.coordinate.latitude)!
//        longitude = (currentLocation?.coordinate.longitude)!
//        
//        let corner1 = CLLocationCoordinate2D(latitude: latitude + 1, longitude: longitude + 1)
//        let corner2 = CLLocationCoordinate2D(latitude: latitude - 1, longitude: longitude - 1)
//        
//        let bounds = GMSCoordinateBounds(coordinate: corner1, coordinate: corner2)
//        
//        resultsViewController = GMSAutocompleteResultsViewController()
//        resultsViewController?.delegate = self
//        
//        resultsViewController?.autocompleteBounds = bounds
//        
//        searchController = UISearchController(searchResultsController: resultsViewController)
////        searchController.
//        searchController?.searchResultsUpdater = resultsViewController
//        
//        
//        
//
//        resultsViewController?.tableCellBackgroundColor = UIColor(white: 1, alpha: 0.1)
//        resultsViewController?.primaryTextHighlightColor = .white
//        resultsViewController?.primaryTextColor = .gray
//        resultsViewController?.secondaryTextColor = .gray
//        
//        let screenSize: CGRect = UIScreen.main.bounds
//
//        
//        // Add the search bar to the right of the nav bar,
//        // use a popover to display the results.
//        // Set an explicit size as we don't want to use the entire nav bar.
//        searchController?.searchBar.frame = (CGRect(x: 0, y: 0, width: screenSize.width - 30, height: 44.0))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: (searchController?.searchBar)!)
////        searchController?.searchBar.layer.borderColor = UIColor.white.cgColor
////        searchController?.searchBar.layer.shadowOpacity = 0.5
//        
//        // When UISearchController presents the results view, present it in
//        // this view controller, not one further up the chain.
//        definesPresentationContext = true
//        
//        // Keep the navigation bar visible.
//        searchController?.hidesNavigationBarDuringPresentation = false
//        searchController?.modalPresentationStyle = .popover
//        
//
//    }
//    
//    
//    
//    func placeAutocomplete() {
//        
//        // Set bounds to inner-west Sydney Australia.
//        
//        let corner1 = CLLocationCoordinate2D(latitude: latitude + 1, longitude: longitude + 1)
//        let corner2 = CLLocationCoordinate2D(latitude: latitude - 1, longitude: longitude - 1)
//        
//        let bounds = GMSCoordinateBounds(coordinate: corner1, coordinate: corner2)
//        
//        let placeClient = GMSPlacesClient()
//        
//        let filter = GMSAutocompleteFilter()
//    }
//
//}
//
//
//// Handle the user's selection.
//extension testVC: GMSAutocompleteResultsViewControllerDelegate {
//    
//    
//    
//
//    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
//                           didAutocompleteWith place: GMSPlace) {
//        
//        let autocompletecontroller = GMSAutocompleteViewController()
////        autocompletecontroller.autocompleteFilter?.type.
//        
//        
//        searchController?.isActive = false
//        
//        // Do something with the selected place.
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
//    }
//    
//    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
//                           didFailAutocompleteWithError error: Error){
//        // TODO: handle the error.
//        print("Error: ", error.localizedDescription)
//    }
//    
//    // Turn the network activity indicator on and off again.
//    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
//    
//    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }

