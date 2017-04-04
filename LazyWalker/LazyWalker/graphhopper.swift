//
//  graphhopper.swift
//  LazyWalker
//
//  Created by Emmet Susslin on 3/23/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import Mapbox
import Alamofire
import Charts
import SwiftCharts
import GooglePlaces

extension mapVC {

    func getGraphopper(destination: CLLocationCoordinate2D) {
        
        // VARIABLES FOR THE DESTINATION LOCATION COORDINATES
        let destiny = destination
        let destLat = destiny.latitude
        let destLong = destiny.longitude
        
        // ORIGIN / DESTINATION COORDINATES ASSEMBLED IN A SINGLE STRING
        let originString = "\(latitude)," + "\(longitude)"
        let deString = "\(destLat)," + "\(destLong)"
        let pointstring = originString + "&point=" + deString
        
        
        // THE COMPLETE STRING FOR GRAPHOPPER - (https://www.graphhopper.com/)
        
        let theString = "https://graphhopper.com/api/1/route?point=" + pointstring + "&vehicle=foot&locale=en&elevation=true&points_encoded=false&ch.disable=true&heading=1&algorithm=alternative_route&alternative_route.max_paths=20&alternative_route.max_weight_factor=4&alternative_route.max_share_factor=2&key=a67e19cf-291b-492b-b380-68405b49e910"

        // BONER?
        var allPathElevations = [Double]()
        
        
        // ALAMOFIRE IS USED TO FIRE OFF THE SINGLE CALL TO GRAPHOPPER'S API
        
        Alamofire.request(theString).responseJSON { response in
            
            
            //
            
            if let JSON = response.result.value as? [String:Any] {
                
                self.adjustCameraForRoutes()

                let pathss = JSON["paths"] as! [[String:Any]]
                
                
                for path in pathss {
                    
                    // PATHS - EACH PATH IS APPENDED TO A THE 'PATHS' ARRAY:    var paths = [[String:Any]]()
                    
                    // EACH PATH WITH BE INVOKED BY ITS INDEX IN THIS ARRAY THROUGHOUT THE APPLICATION
                    
                    paths.append(path)

                    
                    //THE TOTAL ASCENSION (CLIMB) OF EACH ROUTE/PATH IS STORED IN THE 'ASCEND' ARRAY:     var ascend = [Double]()
                    ascend.append((path["ascend"] as? Double)!)
                    //THE TOTAL DESCENSION (DOWNHILL) OF EACH ROUTE/PATH IS STORED IN THE 'DESCEND' ARRAY:     var descend = [Double]()
                    descend.append((path["descend"] as? Double)!)
                    
                    //THE TOTAL DISTANCE OF EACH ROUTE/PATH IS STORED IN THE 'TOTAL DISTANCE' ARRAY:       var totalDistance = [Double]()
                    totalDistance.append((path["distance"] as? Double)!)
                    
                    
                    
                }
                
                
                //AFTER EACH PATH RECIEVED FROM THE API CALL IS UNPACKED THESE 2 FUNCTIONS ARE CALLED
                
                // FUNCTION TO FIND THE FLATTEST ROUTE
                self.flattestRoute()
                
                // FUNCITON TO PREPARE MENU SUBVIEW FOR THE USER TO ASSESS PATH OPTIONS
                self.setMenu()
            }
            
        }
}
    
    
    
    func findRange() {
        
        let sortedRange = elevationRange.sorted()
        minElevation = sortedRange[0]
        maxElevation = sortedRange[sortedRange.count - 1]
        
    }
    
    
    
    // FUNCTION TO DETERMINE THE ORDER AND INDEX OF THE ROUTES BASED ON ASCENSION VALUES
    
    func flattestRoute() {
        
        // FIRST ASCENSION VALUES ARE SORTED FROM SMALLEST TO LARGEST
        let sortedAscend = ascend.sorted()
        
        
        // GRAPHOPPER WILL DELIVER ANYTHING FROM 2 TO 9 ROUTE OPTIONS DEPENDING ON THE ORIGIN / DESTINATION REQUEST
        print("PATHS COUNT")

        // THE INDEX OF EACH PATH WITH REGARD TO 'FLATTNESS'...
        // IS ACHIEVED BY DETERMINING ITS POSITION IN THE 'SORTED-ASCEND' ARRAY
        
        
        if (paths.count > 4) {
            let fiveflattest = ascend.index(of: sortedAscend[4])!
            
            // FUNCTION TO PRINT THE POLYLINE OF THE ROUTE IS CALLED
            //ARGUMENTS: THE INDEX, LINE ID (0-4), AND AN EMPTY ARRAY FOR POINTS
            printLine(index: fiveflattest, id: "4", array: fifthLinePoints)
        }

        if (paths.count > 3) {
            let fourflattest = ascend.index(of: sortedAscend[3])!
            printLine(index: fourflattest, id: "3", array: fourthLinePoints)
        }

        if (paths.count > 2) {
            let threeflattest = ascend.index(of: sortedAscend[2])!
            printLine(index: threeflattest, id: "2", array: thirdLinePoints)
        }

        if (paths.count > 1) {
            let twoflattest = ascend.index(of: sortedAscend[1])!
            printLine(index: twoflattest, id: "1", array: secondLinePoints)
        }

        let flattest = ascend.index(of: sortedAscend[0])!
        printLine(index: flattest, id: "0", array: firstLinePoints)
        
        
        // FUNCITON IS CALLED TO FIND THE COMBINED ELEVATION RANGE (min/max) OF ALL ROUTES
        findRange()
        
    }


}
