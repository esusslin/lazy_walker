//
//  menu.swift
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



//// TOGGLE MENU

        @IBAction func toggleMenu(_ sender: UIButton) {
            
//            self.btn1.addGestureRecognizer
            
            if darkFillView.transform == CGAffineTransform.identity{
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.darkFillView.transform = CGAffineTransform(scaleX: 11, y: 11)
                    self.menuView.transform = CGAffineTransform(translationX: 0, y: -60)

                }) { (true) in
                    self.toggleMenuButton.transform = CGAffineTransform(rotationAngle: self.radians(degrees: 180.0))

                }
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.darkFillView.transform = .identity
                    self.menuView.transform = .identity
                    self.toggleMenuButton.transform = .identity

                }) { (true) in
                    
                }
            }
        }
    

            
            
    
        @IBAction func btn1_pressed(_ sender: UIButton) {
            
            removeSubview()
            removeBold()
            addTapGestureDismissal()
            self.boldline(title: "0")
            self.addAnnotationSubview(index: "0")
            self.addGraphicSubview(index: "0")
        }

        @IBAction func btn2_pressed(_ sender: UIButton) {
            removeSubview()
            removeBold()
            self.boldline(title: "1")
            addTapGestureDismissal()
            self.addAnnotationSubview(index: "1")
            self.addGraphicSubview(index: "1")
        }

        @IBAction func btn3_pressed(_ sender: UIButton) {
            removeSubview()
            removeBold()
            self.boldline(title: "2")
            addTapGestureDismissal()
            self.addAnnotationSubview(index: "2")
            self.addGraphicSubview(index: "2")
        }


        @IBAction func btn4_pressed(_ sender: UIButton) {
            removeSubview()
            removeBold()
            self.boldline(title: "3")
            addTapGestureDismissal()
            self.addAnnotationSubview(index: "3")
            self.addGraphicSubview(index: "3")
        }

        @IBAction func btn5_pressed(_ sender: UIButton) {
            removeSubview()
            removeBold()
            self.boldline(title: "4")
            addTapGestureDismissal()
            self.addAnnotationSubview(index: "4")
            self.addGraphicSubview(index: "4")
        }
    

        func radians(degrees: Double) -> CGFloat {
            return CGFloat(degrees * .pi / degrees)
        }

        func addTapGestureDismissal() {
            let aSelector : Selector = "removeSubview"
            let tapGesture = UITapGestureRecognizer(target:self, action: aSelector)
            self.view.addGestureRecognizer(tapGesture)
        }

        func removeTapGestureDismissal() {
            
            for recognizer in mapView.gestureRecognizers! {
               self.view.removeGestureRecognizer(recognizer)
                print("gesture removed!")
            }
            
        //    flattestRoute()
            
        }




        func setMenu() {
            
            
            
           
           
            
                    menuView.alpha = 1
                    // Create the views dictionary
                    let viewsDictionary = ["btn1":btn1, "btn2":btn2, "btn3":btn3, "btn4":btn4, "btn5":btn5]
                    
                    
                    
                    menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[btn1(44)]-18-|",
                                                                           options: [],
                                                                           metrics: nil,
                                                                           views: viewsDictionary))
                    
                    menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[btn2(44)]-18-|",
                                                                           options: [],
                                                                           metrics: nil,
                                                                           views: viewsDictionary))
                    
                    menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[btn3(44)]-18-|",
                                                                           options: [],
                                                                           metrics: nil,
                                                                           views: viewsDictionary))
                    
                    menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[btn4(44)]-18-|",
                                                                           options: [],
                                                                           metrics: nil,
                                                                           views: viewsDictionary))
                    
                    menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[btn5(44)]-18-|",
                                                                           options: [],
                                                                           metrics: nil,
                                                                           views: viewsDictionary))
                    
                    
                    if paths.count > 4 {
                        
                        //buttons visible
                        btn5.alpha = 1
                        btn4.alpha = 1
                        btn3.alpha = 1
                        btn2.alpha = 1
                        btn1.alpha = 1
                        
                        //POSITION 5 buttons on Menu
                        menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[btn1(44)]-20-[btn2(44)]-20-[btn3(44)]-20-[btn4(44)]-20-[btn5(44)]-40-|",
                                                                               options: [],
                                                                               metrics: nil,
                                                                               views: viewsDictionary))
                    } else if paths.count > 3 {
                        
                        btn4.alpha = 1
                        btn3.alpha = 1
                        btn2.alpha = 1
                        btn1.alpha = 1
                        //POSITION 4 buttons on Menu
                        menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-54-[btn1(44)]-30-[btn2(44)]-30-[btn3(44)]-30-[btn4(44)]-54-|",
                                                                               options: [],
                                                                               metrics: nil,
                                                                               views: viewsDictionary))
                    } else if paths.count > 2 {
                        
                        btn3.alpha = 1
                        btn2.alpha = 1
                        btn1.alpha = 1
                        
                        //POSITION 3 buttons on Menu
                        menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-70-[btn1(44)]-51-[btn2(44)]-51-[btn3(44)]-70-|",
                                                                               options: [],
                                                                               metrics: nil,
                                                                               views: viewsDictionary))
                    } else {
                        btn2.alpha = 1
                        btn1.alpha = 1
                        //POSITION 2 buttons on Menu
                        menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-100-[btn1(44)]-80-[btn2(44)]-100-|",
                                                                               options: [],
                                                                               metrics: nil,
                                                                               views: viewsDictionary))
                    }
            
            
            
            
            
            
        }

}
