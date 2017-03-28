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
        
        let destiny = destination
        
        let destLat = destiny.latitude
        let destLong = destiny.longitude
        
        let originString = "\(latitude)," + "\(longitude)"
        
        let deString = "\(destLat)," + "\(destLong)"
        
        let pointstring = originString + "&point=" + deString
        
        let theString = "https://graphhopper.com/api/1/route?point=" + pointstring + "&vehicle=foot&locale=en&elevation=true&points_encoded=false&ch.disable=true&heading=1&algorithm=alternative_route&alternative_route.max_paths=20&alternative_route.max_weight_factor=4&alternative_route.max_share_factor=2&key=a67e19cf-291b-492b-b380-68405b49e910"
        //
        print(theString)
        var allPathElevations = [Double]()
        
        Alamofire.request(theString).responseJSON { response in
            
            print(response)
            
            
            if let JSON = response.result.value as? [String:Any] {
                
                self.adjustCameraForRoutes()
                
                //                print(response)
                
                let pathss = JSON["paths"] as! [[String:Any]]
                
                
                for path in pathss {
                    
                    let points = path["points"] as? [String:Any]
                    let coords = points?["coordinates"] as! NSArray!
                    
                    print("COORDS COUNTS")
                    print(coords?.count)
                    
                    //                    allPathElevations.append(coords[2])
                    
                    var elevations = [Double]()
                    
                    ascend.append((path["ascend"] as? Double)!)
                    descend.append((path["descend"] as? Double)!)
                    totalDistance.append((path["distance"] as? Double)!)
                    
                    
                    paths.append(path)
                }
                
                self.flattestRoute()
                self.findRange()
                self.setMenu()
            }
            
        }
}
    
    
    
    func findRange() {
        
        let sortedRange = elevationRange.sorted()
        minElevation = sortedRange[0]
        maxElevation = sortedRange[sortedRange.count - 1]
        
    }
    
    
    func flattestRoute() {
        
        let sortedAscend = ascend.sorted()
        
        
        print("PATHS COUNT")
        print(paths.count)

        if (paths.count > 4) {
            
            
            let fiveflattest = ascend.index(of: sortedAscend[4])!
            
            printLine(index: fiveflattest, id: "4", array: fifthLinePoints)
        }
        
        //FOURTH:
        if (paths.count > 3) {
            
            let fourflattest = ascend.index(of: sortedAscend[3])!
            printLine(index: fourflattest, id: "3", array: fourthLinePoints)
        }
        
        //THIRD:
        if (paths.count > 2) {
            let threeflattest = ascend.index(of: sortedAscend[2])!
            printLine(index: threeflattest, id: "2", array: thirdLinePoints)
        }
        
        //SECOND:
        if (paths.count > 1) {
            let twoflattest = ascend.index(of: sortedAscend[1])!
            printLine(index: twoflattest, id: "1", array: secondLinePoints)
        }
        
        
        // FIRST:
        let flattest = ascend.index(of: sortedAscend[0])!
        printLine(index: flattest, id: "0", array: firstLinePoints)
        
        findRange()
        
    }


}
