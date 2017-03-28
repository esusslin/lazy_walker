//
//  directions.swift
//  LazyWalker
//
//  Created by Emmet Susslin on 3/27/17.
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


   @objc func toDirections(withSender sender: MyTapGestureRecognizer) {
        print("BONER DIRECTIONS")
    
//        if let index = sender.id {
//            print(index)
//        }
        let index = Int(sender.id!)!
    
        let path = paths[index]
    
        let points = path["points"]! as! AnyObject!
        let coords = points?["coordinates"] as! NSArray!
    
        print("POINTS")
        print(coords)
    
    print("POINTS COUNT")
    print(coords?.count)
    
        var distanceArray = [String]()
        var textArray = [String]()
        var signArray = [String]()
    
    
    

        let steps = path["instructions"] as! NSArray!
    
            for step in steps! {
                let each = step as AnyObject!
                
                print(each)
                
                let dist = each?["distance"]!
                let distString = String(describing: dist!)
                distanceArray.append(distString)
                
                let txt = each?["text"]!
                let txtString = String(describing: txt!)
                textArray.append(txtString)
                
                let sgn = each?["sign"]!
                let sgnString = String(describing: sgn!)
                signArray.append(sgnString)
                
                print(distString)

                
//                textArray.append(each?["distance"] as! String)
//                signArray.append(each?["sign"] as! String)
//                                print(each?["distance"])
//                                print(each?["distance"])
//                                print(each?["sign"])

                
               
            }
    
        print("ARRAY LENGTHS:")
    
        print(distanceArray.count)
        print(textArray.count)
        print(signArray.count)
    
        print(textArray)
        print(distanceArray)
    print(signArray)
    
    
       
    }
}


//(sender : UITapGestureRecognizer)
