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
import GoogleMaps
import Alamofire



class mapVC: UIViewController, MGLMapViewDelegate {
    
    //    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    
    let locationManager = CLLocationManager()
    
    var latitude: Double?
    
    var longitude: Double?
    
    var coordinates1 = [CLLocationCoordinate2D]()
    var coordinates2 = [CLLocationCoordinate2D]()
    var coordinates3 = [CLLocationCoordinate2D]()
    
    var coordString1 = [String]()
    
    var coordString2 = [String]()
    var coordString3 = [String]()
    

    @IBOutlet var mapView: MGLMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        mapView.delegate = self
        
        mapView.frame = view.bounds
        
        let currentLocation = locationManager.location
        
        self.latitude = currentLocation?.coordinate.latitude
        self.longitude = currentLocation?.coordinate.longitude
        
        print(self.latitude!)
        print(self.longitude!)
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: (self.latitude!), longitude: (self.longitude!)), zoomLevel: 13, animated: false)
        
        // Set the map view‘s delegate property
        mapView.delegate = self
        
        getGraphopper()
    }
    
    func getGraphopper() {
        
        
        
        let theString = "https://graphhopper.com/api/1/route?point=37.784785,-122.397684&point=37.739474,-122.470126&vehicle=foot&locale=en&elevation=true&points_encoded=false&ch.disable=true&algorithm=alternative_route&alternative_route.max_paths=20&alternative_route.max_weight_factor=4&alternative_route.max_share_factor=2&key=454360ab-e1b4-4944-874c-e439b9b8a6c1"
        
        Alamofire.request(theString).responseJSON { response in
           
            
            if let JSON = response.result.value as! [String:AnyObject]! {
                
//                let json = try JSONSerialization.jsonObject(with: JSON!, options:.allowFragments) as! [String:AnyObject]
                
                let paths = JSON["paths"] as! [[String: AnyObject]]!
                
                print(paths!.count)
                
                let pathss = paths!
                
//                print(pathss)
//                print(paths!)
                for path in pathss {
                    let points = path["points"]! as! AnyObject!
                    let coords = points?["coordinates"] as! NSArray!
                    var linecoords = [CLLocationCoordinate2D]()
                    var elevations = [Double]()
                    
//                    print(coords!)
//                    print(coords!.count)
                    
//                    print(coords![0][2])
                    let arry = coords![0] as! NSArray
                    
//                        print(coords!.first)
                    
                     let arry2 = coords![coords!.count - 1] as! NSArray
//                    print(coords!)
                    let beg = arry[2] as! Double
                    let end = arry2[2] as! Double
//
                    let avg = (beg + end) / 2
                    
                    for coord in coords! {
//                        print(coord)
                        //                            print(coord.count)
                        
                        let coordAry = coord as! NSArray
                        let lat = coordAry[1]
                        let lng = coordAry[0]
                        
                        let ht = coordAry[2] as! Double
                        
                        elevations.append(ht)
                        
                        let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
                        
                        linecoords.append(coordpoint)
                        
                    }
                    
                                            print(elevations)
                    print("*******************")
                    print(elevations.count)
                    print("*******************")
                    let sorted = elevations.sorted()
                    
                    let min = sorted.first
                    let max = sorted.last
                    
                    
                    let votesElev = elevations.reduce(0, +) / Double(elevations.count)
                    
                    print("median =" + "\(avg)" + "average elevation =" + "\(votesElev)")
                    print("*******************")
                    print("min/max =" + "\(min) " + " \(max)  start/stop=" + "\(beg) " + " \(end)")
                    print("*******************")

                    let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: linecoords)
                    let shape = MGLPolyline(coordinates: pointer, count: UInt(linecoords.count))
                    
                    
                    self.mapView.addAnnotation(shape)
                }
            }
            }
        }
    
}
