//
//  scrapsViewController.swift
//  LazyWalker
//
//  Created by Emmet Susslin on 2/16/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

import UIKit

class scrapsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
//    func printShortest(index: Int) {
//        
//        //        print("shortest:")
//        //        print(index)
//        let path = self.paths[index]
//        
//        print("boner")
//        
//        let points = path["points"]! as! AnyObject!
//        let coords = points?["coordinates"] as! NSArray!
//        var linecoords = [CLLocationCoordinate2D]()
//        for coord in coords! {
//            
//            let coordAry = coord as! NSArray
//            let lat = coordAry[1]
//            let lng = coordAry[0]
//            
//            let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
//            
//            linecoords.append(coordpoint)
//            
//        }
//        let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: linecoords)
//        let shape = MGLPolyline(coordinates: pointer, count: UInt(linecoords.count))
//        
//        shape.title = "shortest"
//        
//        self.mapView.addAnnotation(shape)
//        
//    }
//    
//    func elevaluation(paths: [[String:Any]]) {
//        
//        for path in paths {
//            
//            self.paths.append(path)
//            
//            let points = path["points"] as? [String:Any]
//            let coords = points?["coordinates"] as! NSArray!
//            var linecoords = [CLLocationCoordinate2D]()
//            var elevations = [Double]()
//            
//            self.ascend.append((path["ascend"] as? Double)!)
//            self.descend.append((path["descend"] as? Double)!)
//            self.distance.append((path["distance"] as? Double)!)
//            
//            
//            for coord in coords! {
//                
//                let coordAry = coord as! NSArray
//                let lat = coordAry[1]
//                let lng = coordAry[0]
//                let ht = coordAry[2] as! Double
//                elevations.append(ht)
//                
//                let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
//                
//                linecoords.append(coordpoint)
//                
//            }
//            
//            let sorted = elevations.sorted()
//            
//            let min = sorted.first
//            let max = sorted.last
//            
//            let avgElev = elevations.reduce(0, +) / Double(elevations.count)
//            print(avgElev)
//            
//            self.avgs.append(avgElev)
//            
//            //            print("median = " + "\(avg)" + "average elevation = " + "\(votesElev)")
//            //            print("*******************")
//            //            print("min/max = " + "\(min!) " + " \(max!)  start/stop = " + "\(beg) " + " \(end)")
//            //            print("*******************")
//            //
//            //
//            //
//            //            let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: linecoords)
//            //            let shape = MGLPolyline(coordinates: pointer, count: UInt(linecoords.count))
//            //            
//            //            self.mapView.addAnnotation(shape)
//            
//        }
//        self.flattestRoute()
//        
//    }
//    
//    func printFourth(index: Int) {
//        
//        let path = self.paths[index]
//        
//        //        print(path)
//        
//        let points = path["points"]! as! AnyObject!
//        let coords = points?["coordinates"] as! NSArray!
//        var linecoords = [CLLocationCoordinate2D]()
//        for coord in coords! {
//            
//            let coordAry = coord as! NSArray
//            let lat = coordAry[1]
//            let lng = coordAry[0]
//            
//            let ht = coordAry[2] as! Double
//            
//            self.firstHts.append(ht)
//            
//            let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
//            
//            linecoords.append(coordpoint)
//            
//        }
//        let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: linecoords)
//        let shape = MGLPolyline(coordinates: pointer, count: UInt(linecoords.count))
//        
//        shape.title = "fourth"
//        
//        self.polylines.append(shape)
//        
//        self.mapView.addAnnotation(shape)
//        
//    }
//    
//    func printFifth(index: Int) {
//        
//        let path = self.paths[index]
//        
//        //        print(path)
//        
//        let points = path["points"]! as! AnyObject!
//        let coords = points?["coordinates"] as! NSArray!
//        var linecoords = [CLLocationCoordinate2D]()
//        for coord in coords! {
//            
//            let coordAry = coord as! NSArray
//            let lat = coordAry[1]
//            let lng = coordAry[0]
//            
//            let ht = coordAry[2] as! Double
//            
//            self.firstHts.append(ht)
//            
//            let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
//            
//            linecoords.append(coordpoint)
//            
//        }
//        let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: linecoords)
//        let shape = MGLPolyline(coordinates: pointer, count: UInt(linecoords.count))
//        
//        shape.title = "fifth"
//        
//        self.polylines.append(shape)
//        
//        self.mapView.addAnnotation(shape)
//        
//    }
//    
//    func printSixth(index: Int) {
//        
//        let path = self.paths[index]
//        
//        //        print(path)
//        
//        let points = path["points"]! as! AnyObject!
//        let coords = points?["coordinates"] as! NSArray!
//        var linecoords = [CLLocationCoordinate2D]()
//        for coord in coords! {
//            
//            let coordAry = coord as! NSArray
//            let lat = coordAry[1]
//            let lng = coordAry[0]
//            
//            let ht = coordAry[2] as! Double
//            
//            self.firstHts.append(ht)
//            
//            let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
//            
//            linecoords.append(coordpoint)
//            
//        }
//        let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: linecoords)
//        let shape = MGLPolyline(coordinates: pointer, count: UInt(linecoords.count))
//        
//        shape.title = "sixth"
//        
//        self.polylines.append(shape)
//        
//        self.mapView.addAnnotation(shape)
//        
//    }
//    
//    func printSeventh(index: Int) {
//        
//        let path = self.paths[index]
//        
//        //        print(path)
//        
//        let points = path["points"]! as! AnyObject!
//        let coords = points?["coordinates"] as! NSArray!
//        var linecoords = [CLLocationCoordinate2D]()
//        for coord in coords! {
//            
//            let coordAry = coord as! NSArray
//            let lat = coordAry[1]
//            let lng = coordAry[0]
//            
//            let ht = coordAry[2] as! Double
//            
//            self.firstHts.append(ht)
//            
//            let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
//            
//            linecoords.append(coordpoint)
//            
//        }
//        let pointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: linecoords)
//        let shape = MGLPolyline(coordinates: pointer, count: UInt(linecoords.count))
//        
//        shape.title = "seventh"
//        
//        self.polylines.append(shape)
//        
//        self.mapView.addAnnotation(shape)
//        
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
