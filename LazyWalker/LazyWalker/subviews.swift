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
        label.text = "Climb: " + "\(Int(sortedAscend[num]))" + " meters, " + "Distance: " + "\(Int(totalDistance[index]))" + " meters"
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
        
//        let aSelector : Selector = "toDirections"
//        let tapGesture = UITapGestureRecognizer(target:self, action: aSelector)
//        
//        annotationView.addGestureRecognizer(tapGesture)
//        
//        
//        self.view.addGestureRecognizer(tapGesture)

        
        self.mapView.addSubview(annotationView)
        
        let aSelector : Selector = "toDirections"
        let tapGesture = MyTapGestureRecognizer(target:self, action: #selector(toDirections(withSender:)))
        tapGesture.id = indexString

        annotationView.addGestureRecognizer(tapGesture)
        
        
//                self.annotationView.addGestureRecognizer(tapGesture)
    }
    
    
    func addGraphicSubview(index: String) {
        
        let indexString = index
        
        
        let num = Int(index)!
        var pointsAry = [CGPoint]()
        
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
        
        customView.frame = CGRect.init(x: 0, y: height - 280, width: screenSize.width - 30, height: 100)
        
        customView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        customView.center.x = self.view.center.x
        customView.layer.cornerRadius = customView.frame.size.width / 16
        
        let xmaximum = pointsAry[pointsAry.count - 1]
        
        print(xmaximum.x)
        
        customView.lineColor = color
        customView.showPoints = false
        //    customView.
        customView.axisColor = .gray
        customView.axisLineWidth = 1
        
        customView.yMin = CGFloat(minElevation)
        customView.xMin = 0.0
        customView.xMax = CGFloat(xmaximum.x)
        customView.yMax = CGFloat(maxElevation + 10)
        customView.data = pointsAry
        customView.tag = 101
        
        //    print("X-RANGES:")
        //    print(customView.xMin)
        //    print(customView.xMax)
        //
        //    print("Y-RANGES:")
        //    print(customView.yMin)
        //    print(customView.yMax)
        
        //    customView.setAxisRange(xMin: 0.0, xMax: customView.xMax, yMin: customView.yMin, yMax: customView.xMax )
        
        //    print(customView.data?.count)
        //    print(customView.yMin)
        //    print(customView.yMax)
        
        
        self.mapView.addSubview(customView)
        
        let aSelector : Selector = "toDirections"
         let tapGesture = MyTapGestureRecognizer(target:self, action: #selector(toDirections(withSender:)))
        tapGesture.id = indexString


        customView.addGestureRecognizer(tapGesture)
    }
    
    func removeSubview() {
        print("Start remove subview")
        if let viewWithTag = self.view.viewWithTag(100) {
            removeBold()
            viewWithTag.removeFromSuperview()
        } else {
            print("No!")
        }
        
        print("Start remove subview")
        if let viewWithTagone = self.view.viewWithTag(101) {
            removeBold()
            viewWithTagone.removeFromSuperview()
        } else {
            print("No!")
        }
        
        self.removeTapGestureDismissal()
    }




}
