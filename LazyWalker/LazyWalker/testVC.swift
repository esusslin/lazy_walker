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
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        

        resultsViewController?.tableCellBackgroundColor = UIColor(white: 1, alpha: 0.1)
        resultsViewController?.primaryTextHighlightColor = .white
        resultsViewController?.primaryTextColor = .gray
        resultsViewController?.secondaryTextColor = .gray

        
        // Add the search bar to the right of the nav bar,
        // use a popover to display the results.
        // Set an explicit size as we don't want to use the entire nav bar.
//        searchController?.searchBar.frame = (CGRect(x: 0, y: 0, width: 250.0, height: 44.0))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: (searchController?.searchBar)!)
//        searchController?.searchBar.layer.borderColor = UIColor.white.cgColor
//        searchController?.searchBar.layer.shadowOpacity = 0.5
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Keep the navigation bar visible.
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.modalPresentationStyle = .popover
        
//        searchBtn.frame = CGRect.init(x: 0, y: 100, width: mySearchBar.frame.size.width / 2, height: 30)
//        searchBtn.center.x = self.view.center.x
//        searchBtn.center.y = self.mySearchBar.center.y + 50
//        searchBtn.layer.cornerRadius = 8
//        searchBtn.layer.borderWidth = 1;
//        searchBtn.layer.borderColor = UIColor.white.cgColor
//        searchBtn.layer.shadowOpacity = 0.5
//        searchBtn.alpha = 0
    }
    
    
}
// Handle the user's selection.
extension testVC: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
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
