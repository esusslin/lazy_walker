//
//  lines.swift
//  LazyWalker
//
//  Created by Emmet Susslin on 3/15/17.
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
    
    func loadFirstPhotoForPlace(placeID: String) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto)
                }
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                
                let image = self.convertImageToBW(image:photo!);
                self.imageView.image = image;
                
                
//                self.imageView.sizeThatFits(CGSize(width: 100, height: 100))
                
                
//                self.imageShow()
//                self.attributionTextView.attributedText = photoMetadata.attributions;
            }
        })
    }
    
    func convertImageToBW(image:UIImage) -> UIImage {
        
        let filter = CIFilter(name: "CIPhotoEffectMono")
        
        // convert UIImage to CIImage and set as input
        
        let ciInput = CIImage(image: image)
        filter?.setValue(ciInput, forKey: "inputImage")
        
        // get output CIImage, render as CGImage first to retain proper UIImage scale
        
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        
        return UIImage(cgImage: cgImage!)
    }


    func addAnnotationSubview(index: String) {
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        let annotationView = UIView()
        
        annotationView .frame = CGRect.init(x: 0, y: height - 280, width: screenSize.width / 2, height: 30)
        
        self.mapView.addSubview(annotationView)
    }
    

func addGraphicSubview(index: String) {
    
  
    
    
    let num = Int(index)!
    var pointsAry = [CGPoint]()
    print(num)
    
    var customView = LineChart()
    customView.data = nil
    
    customView.xMin = 0.0
    customView.xMax = 0.0
    customView.yMin = 0.0
    customView.yMax = 0.0
    
    var color = UIColor()
    
    if num == 0 {
        pointsAry = firstCoords
        color = .green
    }
    
    if num == 1 {
        pointsAry = secondCoords
        color = UIColor(red: 127.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1)
    }
    
    if num == 2 {
        pointsAry = thirdCoords
        color = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1)
    }
    
    if num == 3 {
        pointsAry = fourthCoords
        color = UIColor(red: 255.0/255.0, green: 150.0/255.0, blue: 0.0/255.0, alpha: 1)
    }
    
    if num == 4 {
        pointsAry = fifthCoords
        color = .red
    }

    let screenSize: CGRect = UIScreen.main.bounds
    
    let width = self.view.frame.size.width
    let height = self.view.frame.size.height
    
    customView.frame = CGRect.init(x: 0, y: height - 200, width: screenSize.width - 30, height: 100)
    
    customView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
    customView.center.x = self.view.center.x
    customView.layer.cornerRadius = customView.frame.size.width / 16
    
    let xmaximum = pointsAry[pointsAry.count - 1]
    
    print(xmaximum.x)
    
    customView.lineColor = color
    customView.showPoints = false
    customView.axisColor = .gray
    customView.axisLineWidth = 1
    customView.yMin = CGFloat(minElevation)
    customView.xMin = 0.0
    customView.xMax = CGFloat(xmaximum.x)
//    customView.xMax = CGFloat(4000)
    customView.yMax = CGFloat(maxElevation + 10)
    customView.data = pointsAry
    customView.tag = 100
    
    print("X-RANGES:")
    print(customView.xMin)
    print(customView.xMax)
    
    print("Y-RANGES:")
    print(customView.yMin)
    print(customView.yMax)
    
//    customView.setAxisRange(xMin: 0.0, xMax: customView.xMax, yMin: customView.yMin, yMax: customView.xMax )
    
    print(customView.data?.count)
    print(customView.yMin)
    print(customView.yMax)
    
    
    self.mapView.addSubview(customView)
}
    
    func removeSubview() {
        print("Start remove subview")
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
    }
    
    
    
    // DIVIDE POLYLINE FOR ACCURACY:
    
    
    func add(coordinate: CLLocationCoordinate2D, id: String) {
        DispatchQueue.main.async {
            // Unowned reference to self to prevent retain cycle
            
            
            
            let point = pathAnnotation()
            point.coordinate = coordinate
            point.title = id
            //            point.subtitle = "\(coordinate.latitude) / \(coordinate.longitude)"
            self.mapView.addAnnotation(point)
        }
    }
    
    func split(_ from: CLLocationCoordinate2D, _ to: CLLocationCoordinate2D, _ id: String) {
        
        if distance(from, to) > 40 { // THRESHOLD is 200m
            let middle = mid(from, to)
            add(coordinate: middle, id: id)
            split(from, middle, id)
            split(middle, to, id)
        }
        
        add(coordinate: from, id: id)
        add(coordinate: to, id: id)
        
        
    }
    
    func distanceElevation(points: NSArray, id: String) {
        
        var coordAry = [CLLocationCoordinate2D]()
        
        var htAry = [Double]()
        
        for point in points {
            
            let pointAry = point as! NSArray
            
            htAry.append(pointAry[2] as! Double)
            
            let coordinates = CLLocationCoordinate2D(latitude: pointAry[1] as! CLLocationDegrees, longitude: pointAry[0] as! CLLocationDegrees)
            
            coordAry.append(coordinates)
        }
        
        var distanceCounter = 0.0
        
        for (index, _) in coordAry.enumerated() {
            
            
            
            if index == 0 { continue } // skip first
            
            
            let distance = self.distance(coordAry[index - 1], coordAry[index])
            
            distanceCounter += distance
            
//            let point = [distanceCounter, htAry[index]] as! NSArray
            
            let point = CGPoint(x: distanceCounter, y: htAry[index])
            
            print(point)
            
            if id == "0" {
                firstCoords.append(point)
            }
            if id == "1" {
                secondCoords.append(point)
            }
            if id == "2" {
                thirdCoords.append(point)
            }
            
            if id == "3" {
                fourthCoords.append(point)
            }
            
            if id == "4" {
                fifthCoords.append(point)
            }
            
            
        }
        

    }
    
    
    func distance(_ from: CLLocationCoordinate2D, _ to: CLLocationCoordinate2D) -> Double {
        let fromLoc = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLoc = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLoc.distance(from: toLoc)
    }
    
    func mid(_ from: CLLocationCoordinate2D, _ to: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let latitude = (from.latitude + to.latitude) / 2
        let longitude = (from.longitude + to.longitude) / 2
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    
    

}
