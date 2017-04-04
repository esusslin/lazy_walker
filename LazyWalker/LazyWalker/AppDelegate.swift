//
//  AppDelegate.swift
//  LazyWalker
//
//  Created by Emmet Susslin on 2/9/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import Mapbox
import GooglePlaces
import GooglePlacePicker
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    


    var window: UIWindow?
    
    var locationManager: CLLocationManager?
    var coordinate: CLLocationCoordinate2D?
    var lastCoordinate: CLLocationCoordinate2D?



        func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {

            
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let vc = self.window?.rootViewController?.presentedViewController as? mapVC {
            
        }

        
    }
    

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSPlacesClient.provideAPIKey("AIzaSyDMwIMkdZJIpz9Q6qJPI_E6SvAVLen9dEg")
        GMSServices.provideAPIKey("AIzaSyDMwIMkdZJIpz9Q6qJPI_E6SvAVLen9dEg")
        
        locationManagerStart()
        return true
    }
    
    
    //MARK: LocationManager functions
    
    func locationManagerStart() {
        
//
        
        if locationManager == nil {
            print("init locationManager")
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
            
            if (CLLocationManager.headingAvailable()) {
                            locationManager!.headingFilter = 1
                            locationManager!.startUpdatingHeading()
                //            locationManager!.delegate = self
                        }

        }
        
        print("have location manager!")
        locationManager!.startUpdatingLocation()
        
         print("have heading direction!")
        locationManager!.startUpdatingHeading()
        
    }
    
    func locationManagerStop() {
        locationManager!.stopUpdatingLocation()
    }
    
    // MARK: CLLocation Delegate
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        coordinate = newLocation.coordinate
        lastCoordinate = oldLocation.coordinate
        print("NEW COORDS")
        print(coordinate)
        print(oldLocation.coordinate)
//        mapVC.updateDistLbl(coordinate)

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

   
}
}
