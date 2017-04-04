//
//  subviews.swift
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


    // GOOGLE IMAGES ARE RECIEVED

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
    
    // GOOGLE IMAGES ARE RECIEVED
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                
                let image = self.convertImageToBW(image:photo!);
                self.imageView.image = image;

            }
        })
    }
    
    // GOOGLE IMAGE IS CONVERTED TO BLACK AND WHITE
    
    func convertImageToBW(image:UIImage) -> UIImage {
        
        let filter = CIFilter(name: "CIPhotoEffectMono")
        
        let ciInput = CIImage(image: image)
        filter?.setValue(ciInput, forKey: "inputImage")

        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        
        return UIImage(cgImage: cgImage!)
    }
    
    
    // FUNCTION THAT PROVIDES THE TOTAL CLIMB (ASCENSION) AND DISTANCE OF EACH ROUTE:
    
    func addAnnotationSubview(index: String) {
        
        let indexString = index
        
        let num = Int(index)!
        let sortedAscend = ascend.sorted()
        let index = ascend.index(of: sortedAscend[num])!
        
        let screenSize: CGRect = UIScreen.main.bounds
        let width = screenSize.width
        let height = screenSize.height
        
        let annotationView = UIView()
        
        annotationView.frame = CGRect.init(x: 0, y: height - 180, width: width - 40, height: 30)
        annotationView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        annotationView.center.x = self.view.center.x
        annotationView.layer.cornerRadius = annotationView.frame.size.width / 16
        annotationView.tag = 100

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        let distString = metersToMilesString(meters: totalDistance[index])
        label.text = "Climb: " + "\(Int(sortedAscend[num]))" + " meters, " + "Distance: " + distString
        label.numberOfLines=1
        label.backgroundColor = UIColor.clear
        label.textColor = .white
        label.font=UIFont.systemFont(ofSize: 14)
        annotationView.addSubview(label)
        
        let horConstraint = NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal,
                                               toItem: annotationView, attribute: .centerX,
                                               multiplier: 1.0, constant: 0.0)
        let verConstraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal,
                                               toItem: annotationView, attribute: .centerY,
                                               multiplier: 1.0, constant: 0.0)
        let widConstraint = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal,
                                               toItem: annotationView, attribute: .width,
                                               multiplier: 0.95, constant: 0.0)
        let heiConstraint = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal,
                                               toItem: annotationView, attribute: .height,
                                               multiplier: 0.95, constant: 0.0)
        
        annotationView.addConstraints([horConstraint, verConstraint, widConstraint, heiConstraint])

        
        self.mapView.addSubview(annotationView)
        
        let aSelector : Selector = "toDirections"
        let tapGesture = MyTapGestureRecognizer(target:self, action: #selector(toDirections(withSender:)))
        tapGesture.id = indexString

        annotationView.addGestureRecognizer(tapGesture)

    }
    
    
    
    // SUBVIEW WITH ELEVATION CHART IS CREATED AND APPLIED
    
    func addGraphicSubview(index: String) {
        
        // INDEX OF THE PATH BASED ON THE CALL
        let indexString = index

        let num = Int(index)!
        var pointsAry = [CGPoint]()
        
        // LINECHART IS CREATED
        
        // AXIS' ARE RESET:
        var customView = LineChart()
        customView.data = nil
        customView.xMin = 0.0
        customView.xMax = 0.0
        customView.yMin = 0.0
        customView.yMax = 0.0

        
        //THE CORRESPONDING COLOR IS GIVEN:
        
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
        
        customView.frame = CGRect.init(x: 0, y: height - 280, width: screenSize.width - 30, height: 100)
        customView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        customView.center.x = self.view.center.x
        customView.layer.cornerRadius = customView.frame.size.width / 16

        let xmaximum = pointsAry[pointsAry.count - 1]
        customView.lineColor = color
        customView.showPoints = false
        customView.axisColor = .gray
        customView.axisLineWidth = 1
        
        // THE RANGE OF BOTH THE X AND Y AXIS ARE SET BASED ON THE DISTANCE AND ELEVATION RANGE OF THE PATHS
        customView.yMin = CGFloat(minElevation)
        customView.xMin = 0.0
        customView.xMax = CGFloat(xmaximum.x)
        customView.yMax = CGFloat(maxElevation + 10)
        customView.data = pointsAry
        
        //CHART SUBVIEW IS TAG'D WITH AN ID, LATER USED TO REMOVE IT
        customView.tag = 101
        
        // CHART SUBVIEW IS ADDED TO THE MAP
        self.mapView.addSubview(customView)
        
        
            // SUBVIEW IS GIVEN A TAP GESTURE RECOGNIZER
           // IF THE USER DECIDES TO PERSUE THE SELECTED ROUTE
          //THE USER CAN SIMPLY TAP ON THE SUBVIEW TO MOVE TO THE DIRECTIONS MODE OF THE APPLICATION
        
        let aSelector : Selector = "toDirections"
         let tapGesture = MyTapGestureRecognizer(target:self, action: #selector(toDirections(withSender:)))
        tapGesture.id = indexString

        customView.addGestureRecognizer(tapGesture)
    }
    
    
    // SUBVIEWS ARE REMOVED IF DE-SELECTED
    func removeSubview() {
        
        if let viewWithTag = self.view.viewWithTag(100) {
            removeBold()
            viewWithTag.removeFromSuperview()
        } else {
            print("No!")
        }

        if let viewWithTagone = self.view.viewWithTag(101) {
            removeBold()
            viewWithTagone.removeFromSuperview()
        } else {
            print("No!")
        }
        
        self.removeTapGestureDismissal()
    }




}
