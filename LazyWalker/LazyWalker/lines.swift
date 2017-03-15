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

func addGraphicSubview(index: String) {
    
    let num = Int(index)!
    
    var pointsAry = [NSArray]()
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
    
    
    
    for point in pointsAry {
        let dot = (point[0] as! Double, point[1] as! Double)
        pointArr.append(dot as! (Double, Double))
    }
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    let width = self.view.frame.size.width
    let height = self.view.frame.size.height
    
    
    customView.frame = CGRect.init(x: 0, y: height - 200, width: screenSize.width - 30, height: 85)
    
    customView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
    customView.center.x = self.view.center.x
    customView.layer.cornerRadius = customView.frame.size.width / 16
    
    
    let sortedAscend = ascend.sorted()
    
    let chartConfig = ChartConfigXY(
        xAxisConfig: ChartAxisConfig(from: 0, to: totalDistanceOverall as! Double, by: 2),
        yAxisConfig: ChartAxisConfig(from: 0, to: sortedAscend[sortedAscend.count - 1] + 100, by: 2)
    )
    
    //        let chartdata = LineChartDataSet
    
    let chart = LineChart(
        frame: CGRect.init(x: 0, y: 50, width: screenSize.width - 35, height: 80),
        chartConfig: chartConfig,
        xTitle: "X axis",
        yTitle: "Y axis",
        lines: [
            (chartPoints: pointArr, color: color),
            //                (chartPoints: [(2.0, 2.6), (4.2, 4.1), (7.3, 1.0), (8.1, 11.5), (14.0, 3.0)], color: .blue)
        ]
    )
    
    
    
    self.customView.addSubview(chart.view)
    
    //        chart.view.center = customView.center
    
    self.view.addSubview(customView)
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
            
            let point = [distanceCounter, htAry[index]] as! NSArray
            
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
