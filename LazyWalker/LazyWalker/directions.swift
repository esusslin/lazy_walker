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



var currentDestination = CLLocationCoordinate2D()
var currentOrigin = CLLocationCoordinate2D()
var currentDestinationDirection = Double()

var distanceArray = [String]()
var textArray = [String]()
var signArray = [String]()
var intervalArray = [NSArray]()
var coordsArray = [CLLocationCoordinate2D]()
var segmentPoints = [CLLocationCoordinate2D]()


var progCount = Int()

extension mapVC {


   @objc func toDirections(withSender sender: MyTapGestureRecognizer) {
        print("TO DIRECTIONS")

        let index = Int(sender.id!)!
    
        removeExtraRoutes(index: index)
    
        let path = paths[index]
    
        progCount = 0
    
        let points = path["points"]! as! AnyObject!
        let arrayOfCoords = points?["coordinates"] as! NSArray!
    
            for coord in arrayOfCoords! {
                
                let coordAry = coord as! NSArray
                
                let elevation = coordAry[2]
                
                elevationRange.append(elevation as! Double)
                
                let lat = coordAry[1]
                let lng = coordAry[0]
                
                let ht = coordAry[2]
                
                let point = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: lng as! CLLocationDegrees)
                
                let coordpoint = CLLocationCoordinate2DMake(lat as! Double, lng as! Double)
                
                coordsArray.append(coordpoint)
                
            }
    
    

        let steps = path["instructions"] as! NSArray!
    
            for step in steps! {
                let each = step as AnyObject!
                
                let dist = each?["distance"]!
                let distString = String(describing: dist!)
                distanceArray.append(distString)
                
                let txt = each?["text"]!
                let txtString = String(describing: txt!)
                textArray.append(txtString)
                
                let sgn = each?["sign"]!
                let sgnString = String(describing: sgn!)
                signArray.append(sgnString)
                
                let interval = each?["interval"] as? NSArray!

                intervalArray.append(interval!)
                
                print(distString)
               
            }

    
    
    startMap()
    segments()
    
    }
    
    func segments() {
        
        
        var segs = [Int]()
        
        for int in intervalArray {
            let inx2 = int[1]
            
            segs.append(inx2 as! Int)

        }
        
        for seg in segs {
            
            let segCoord = coordsArray[seg]
            
            segmentPoints.append(segCoord)
           
        }

        
    }
    
    func removeExtraRoutes(index: Int) {
        
        readySubview(index: index)
        
        print("REMOVE ALL BUT:")
         print(index)
        
        let indexString = String(index)
        
        let poly = mapView.annotations?.filter { annotation in
            
            return (annotation.title??.localizedCaseInsensitiveContains(indexString) == false)
            
        }

        for pol in poly! {
                mapView.removeAnnotation(pol)
            }
        
        let theRoute = mapView.annotations?.filter { annotation in
            
            return (annotation.title??.localizedCaseInsensitiveContains("BOLD") == true)
            
        }
        
        for route in theRoute! {
            mapView.removeAnnotation(route)
            let shape = route as! MGLPolyline
            let newtitle = (indexString + "BOLD")
            
            shape.title = newtitle
            
            self.mapView.addAnnotation(shape)
            
        }
        
    }

       
    
    
    func startMap() {
        
        
        
        setLocation()
        
        progCount = 0
       
        adjustCameraForSelection()
        

        }
    
    
    
    
    func metersToMilesString(meters: Double) -> String {
        
        let x = (meters * 0.000621371)
        if (x < 0.00473) {
            return "25 ft"
        }
        else if (x < 0.00946) {
            return "50 ft"
        }
        else if (x < 0.019) {
            return "100 ft"
        } else if (x < 0.04) {
            return "200 ft"
        } else if (x < 0.06) {
            return "300 ft"
        } else if (x < 0.08) {
            return "400 ft"
        } else if (x < 0.09) {
            return "500 ft"
        } else {
            let y = Double(round(100*x)/100)
            let string = String(y)
            return string + " mi"
        }
        
    }
    
    
    //// TOGGLE TABLE
    
    @IBAction func toggleTable(_ sender: UIButton) {
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        if tableDarkView.transform == CGAffineTransform.identity {
            
            UIView.animate(withDuration: 0.8, animations: {
                
                self.tableView.transform = CGAffineTransform(translationX: 0, y: -340)
                
                self.tableDarkView.transform = CGAffineTransform(translationX: 0, y: -340)
                self.tableToggleButton.transform = CGAffineTransform(translationX: 0, y: -340)
                
                //                self.tableToggleButton.transform = CGAffineTransform(translationX: 0, y: -340)
                
            }) { (true) in
                
                //                let image = UIImage(named: "down")
                self.tableToggleButton.setImage( UIImage.init(named: "down"), for: .normal)
                
            }
        } else {
            UIView.animate(withDuration: 0.8, animations: {
                self.tableDarkView.transform = .identity
                self.tableView.transform = .identity
                self.tableToggleButton.transform = .identity
                
                
            }) { (true) in
                self.tableToggleButton.setImage( UIImage.init(named: "up"), for: .normal)
            }
            
        }
    }
    
    func radians(degrees: Double) -> CGFloat {
        return CGFloat(degrees * .pi / degrees)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.alpha = 0.5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! directionsCell
        
        cell.label.text = textArray[indexPath.row]
        cell.label.textColor = .white
        
        let metersDouble = Double(distanceArray[indexPath.row])
        let milesDouble = metersToMilesString(meters: metersDouble!)
        
        let milesString = String(describing: milesDouble)
        
        cell.distanceLabel.text = milesDouble
        
        cell.distanceLabel.textColor = .white
        
        cell.distanceLabel.textColor = .red
        
        
        print("direction:")
        print(signArray)
        
        if signArray[indexPath.row] == "-3" || signArray[indexPath.row] == "-2" {
            cell.arrowPic.image = UIImage.init(named: "left")
            
        }
        
        if signArray[indexPath.row] == "-1" {
            cell.arrowPic.image = UIImage.init(named: "slight-left")
            
        }
        if signArray[indexPath.row] == "0" {
            cell.arrowPic.image = UIImage.init(named: "straight")
            
        }
        if signArray[indexPath.row] == "1" {
            cell.arrowPic.image = UIImage.init(named: "slight-right")
            
        }
        
        if signArray[indexPath.row] == "2" || signArray[indexPath.row] == "3" {
            cell.arrowPic.image = UIImage.init(named: "right")
            
        }
        
        if signArray[indexPath.row] == "6"  {
            cell.arrowPic.image = UIImage.init(named: "round")
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArray.count
    }

    
    
       
    
    
    func geoStart() {

        self.directionSubview.alpha = 0
        self.tableToggleButton.alpha = 0
        self.tableDarkView.alpha = 0
        self.tableView.alpha = 0
        
        self.cancelBtn.alpha = 0
        self.centerMapBtn.alpha = 0
        self.goBTn.alpha = 0
        
        print("COUNTER")
        print(progCount)
        
        
        currentDestination = segmentPoints[progCount]
        
        let curLat = currentDestination.latitude
        let curLng = currentDestination.longitude
        
        print(currentDestination)
        
        bearingToLocationDegreesDirections(destinationLocation: CLLocation(latitude: curLat, longitude: curLng))
        
        adjustCameraGO()
        
        progCount += 1
        progressSubview()

        
    }
    
    func progressSubview() {
        

        let screenSize: CGRect = UIScreen.main.bounds
        let width = screenSize.width
        let height = screenSize.height
        
        self.nextSubview.frame = CGRect.init(x: 0, y: height - 180, width: width - 10, height: 100)
        self.nextSubview.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.nextSubview.center.x = self.view.center.x
        self.nextSubview.center.y = (self.view.frame.size.height + 120) - self.view.frame.size.height
        
        
        self.nextSubview.layer.cornerRadius = directionSubview.frame.size.width / 22
        self.nextSubview.tag = 102
        
        let directionText = textArray[progCount]
        
        nextLbl.text = directionText
        nextLbl.alpha = 1
        nextLbl.font=UIFont.systemFont(ofSize: 16)
        
        let x = distance(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), currentDestination)

        
        distLbl.text = metersToMilesString(meters: x)
        distLbl.alpha = 1
        print(distLbl.text)
        distLbl.font=UIFont.systemFont(ofSize: 12)
        distLbl.textColor = .red
        distLbl.center.x = nextSubview.center.x
        
        let y = Double(round(100*x)/100)
        
        
        if signArray[progCount] == "-3" || signArray[progCount] == "-2" {
            arrowPic.image = UIImage.init(named: "left")
            
        }
        
        if signArray[progCount] == "-1" {
            arrowPic.image = UIImage.init(named: "slight-left")
            
        }
        if signArray[progCount] == "0" {
            arrowPic.image = UIImage.init(named: "straight")
            
        }
        if signArray[progCount] == "1" {
            arrowPic.image = UIImage.init(named: "slight-right")
            
        }
        
        if signArray[progCount] == "2" || signArray[progCount] == "3" {
            arrowPic.image = UIImage.init(named: "right")
            
        }
        
        if signArray[progCount] == "6"  {
            arrowPic.image = UIImage.init(named: "round")
            
        }
        
        
       let viewsDictionary = ["pic":arrowPic, "label":nextLbl, "distlbl":distLbl] as [String : Any]
        
//        nextSubview.translatesAutoresizingMaskIntoConstraints = false
        nextLbl.translatesAutoresizingMaskIntoConstraints = false
        arrowPic.translatesAutoresizingMaskIntoConstraints = false
        distLbl.translatesAutoresizingMaskIntoConstraints = false
        
        nextSubview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[pic(16)]-20-[label]-20-|",
                                                                       options: [],
                                                                       metrics: nil,
                                                                       views: viewsDictionary))
        
        nextSubview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[distlbl]-40-|",
                                                                  options: [],
                                                                  metrics: nil,
                                                                  views: viewsDictionary))
        
        nextSubview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[pic(16)]-10-|",
                                                                  options: [],
                                                                  metrics: nil,
                                                                  views: viewsDictionary))
        
        nextSubview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[label]-20-[distlbl]-20-|",
                                                                  options: [],
                                                                  metrics: nil,
                                                                  views: viewsDictionary))
        
        print("CENTERS")
        
        print(arrowPic.center)
        print(nextLbl.center)
        print(distLbl.center)
        self.nextSubview.alpha = 1
        
    }
    
    
   
       
    
    func mapProgress() {
        
        setLocation()
        
    }
    
    
    
    
    // MAP CAMERA
    
    //    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
    
    func adjustCameraGO() {
        
        
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 50, pitch: 80, heading: (currentDestinationDirection))
        
        // Animate the camera movement over 5 seconds.
        mapView.setCamera(camera, withDuration: 3, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        
        
    }

    
    func adjustCameraForSelection() {

        
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: totalDistanceOverall*0.8, pitch: 60, heading: (destinationDirection))
        
        print("TOTAL DISTANCE")
        print(totalDistanceOverall)
        
        // Animate the camera movement over 5 seconds.
        mapView.setCamera(camera, withDuration: 3, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        
//        self.imageShow()
        prepareViewForSelection()
    }
    
    
    func prepareViewForSelection() {
        
        tableView.reloadData()
        removeSubview()
        startChain()
        
    }
    
    func startChain() {
        UIView.animate(withDuration: 1, animations: { 
            self.menuView.alpha = 0
        }) { (true) in
            self.showButton()
        }
    }
    
    func showButton() {
        UIView.animate(withDuration: 1, animations: {
            self.tableToggleButton.alpha = 1
            self.tableDarkView.alpha = 1
        }) { (true) in
            self.showTable()
        }

    }
    
    func showTable() {
        UIView.animate(withDuration: 1.2, animations: {
            self.tableView.alpha = 1
        
        }) { (true) in
           self.showView()
        }

    }
    
    func showView() {
        UIView.animate(withDuration: 1.2, animations: {
            self.directionSubview.alpha = 1
            
        }) { (true) in
            self.showMapBtns()
        }
        
    }
    
    func showMapBtns() {
        
        cancelBtn.alpha = 0
        centerMapBtn.alpha = 0
        goBTn.alpha = 0
        
        self.centerMapBtn.center.x = self.view.frame.size.width - 40
        self.centerMapBtn.center.y = self.directionSubview.center.y
        
        self.cancelBtn.center.x = self.tableToggleButton.center.x
        self.cancelBtn.center.y = self.directionSubview.center.y
        
        self.goBTn.center.x = self.view.frame.size.width - 40
        self.goBTn.center.y = self.tableToggleButton.center.y
        
        
        self.directionSubview.center.y = (self.view.frame.size.height + 100) - self.view.frame.size.height

        
        UIView.animate(withDuration: 1.2, animations: {
            self.cancelBtn.alpha = 1
            self.centerMapBtn.alpha = 1
           self.goBTn.alpha = 1
            
        }) { (true) in
            //            self.showView()
        }

        
    }

    
    func readySubview(index: Int) {
    
            let indexString = index
            
            let num = Int(index)
            let sortedAscend = ascend.sorted()
            let index = ascend.index(of: sortedAscend[num])!
            
            let screenSize: CGRect = UIScreen.main.bounds
            let width = screenSize.width
            let height = screenSize.height
        
            let totalMeters = Double(totalDistance[index])
        
            let totalMiles = metersToMilesString(meters: totalMeters)

        
            self.directionSubview.frame = CGRect.init(x: 0, y: height - 180, width: width - 40, height: 40)
            self.directionSubview.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.directionSubview.center.x = self.view.center.x
            self.directionSubview.center.y = (self.view.frame.size.height + 100) - self.view.frame.size.height

            self.directionSubview.layer.cornerRadius = directionSubview.frame.size.width / 22
            self.directionSubview.tag = 102
        
            self.directionSubview.alpha = 0

                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.textAlignment = .center
                label.text = "\(Int(sortedAscend[num]))" + " meters uphill, " + totalMiles + "total"
                label.numberOfLines=1
                label.backgroundColor = UIColor.clear
                label.textColor = .white
                label.font=UIFont.systemFont(ofSize: 14)
                self.directionSubview.addSubview(label)
                
                let horConstraint = NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal,
                                                       toItem: directionSubview, attribute: .centerX,
                                                       multiplier: 1.0, constant: 0.0)
                let verConstraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal,
                                                       toItem: directionSubview, attribute: .centerY,
                                                       multiplier: 1.0, constant: 0.0)
                let widConstraint = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal,
                                                       toItem: directionSubview, attribute: .width,
                                                       multiplier: 0.95, constant: 0.0)
                let heiConstraint = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal,
                                                       toItem: directionSubview, attribute: .height,
                                                       multiplier: 0.95, constant: 0.0)
                
                directionSubview.addConstraints([horConstraint, verConstraint, widConstraint, heiConstraint])

        
       
    }
    
    
    
    func adjustCameraForDirections() {
        
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 10, pitch: 80, heading: (currentDestinationDirection))
        
        // Animate the camera movement over 5 seconds.
        mapView.setCamera(camera, withDuration: 3, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        
        self.imageShow()
    }
    
    
    func bearingToLocationRadian(destinationLocation:CLLocation) -> Double {
        
        let lat1 = DegreesToRadians(degrees: latitude)
        let lon1 = DegreesToRadians(degrees: longitude)
        
        print("latlong1")
        print(lat1)
        print(lon1)
        
        let lat2 = DegreesToRadians(degrees: destinationLocation.coordinate.latitude);
        let lon2 = DegreesToRadians(degrees: destinationLocation.coordinate.longitude);
        
        print("latlong2")
        print(lat2)
        print(lon2)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        let radiansBearing = atan2(y, x)
        
        return radiansBearing
    }
    
    func bearingToLocationDegreesDirections(destinationLocation:CLLocation) -> Double{
        let heading = RadiansToDegrees(radians: bearingToLocationRadian(destinationLocation: destinationLocation))
        print("HEADING THIS DIRECTION:")
        print(heading)
        
        let degrees = (360.0 + heading) as! Double!
        
        print("DEGREES")
        print(degrees)
        
        currentDestinationDirection = degrees!
        
        return heading
    }

    
    func bearingToLocationDegrees(destinationLocation:CLLocation) -> Double{
        let heading = RadiansToDegrees(radians: bearingToLocationRadian(destinationLocation: destinationLocation))
        print("HEADING THIS DIRECTION:")
        print(heading)
        
        let degrees = (360.0 + heading) as! Double!
        
        print("DEGREES")
        print(degrees)
        
        destinationDirection = degrees!
        
        return heading
    }



}


