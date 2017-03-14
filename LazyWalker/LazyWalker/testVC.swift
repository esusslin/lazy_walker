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
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        

        resultsViewController?.tableCellBackgroundColor = UIColor(white: 1, alpha: 0.1)
        resultsViewController?.primaryTextHighlightColor = .white
        resultsViewController?.primaryTextColor = .gray
        resultsViewController?.secondaryTextColor = .gray
        
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
        

    }
    
    
    
    func placeAutocomplete() {
        
        // Set bounds to inner-west Sydney Australia.
        
        let corner1 = CLLocationCoordinate2D(latitude: latitude + 1, longitude: longitude + 1)
        let corner2 = CLLocationCoordinate2D(latitude: latitude - 1, longitude: longitude - 1)
        
        let bounds = GMSCoordinateBounds(coordinate: corner1, coordinate: corner2)
        
        let placeClient = GMSPlacesClient()
        
        let filter = GMSAutocompleteFilter()
    }

}


// Handle the user's selection.
extension testVC: GMSAutocompleteResultsViewControllerDelegate {
    
    
    

    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        
        let autocompletecontroller = GMSAutocompleteViewController()
//        autocompletecontroller.autocompleteFilter?.type.
        
        
        searchController?.isActive = false
        
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
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
