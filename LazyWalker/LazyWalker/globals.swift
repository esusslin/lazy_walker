//
//  globals.swift
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


//// GLOBALS

let locationManager = CLLocationManager()

var latitude = Double()
var longitude = Double()

var destination = CLLocationCoordinate2D()
var origin = CLLocationCoordinate2D()
var destinationDirection = Double()

// FOR ALL ROUTES
var paths = [[String:Any]]()

// UNIQUE VALUES OF EACH ROUTE

var ascend = [Double]()
var descend = [Double]()
var totalDistance = [Double]()

var totalDistanceOverall = Double()

// ALL COORDINATES

var firstCoords = [CGPoint]()
var secondCoords = [CGPoint]()
var thirdCoords = [CGPoint]()
var fourthCoords = [CGPoint]()
var fifthCoords = [CGPoint]()

var elevationRange = [Double]()

var minElevation = Double()
var maxElevation = Double()

//var pointsAry = [CGPoint]()
