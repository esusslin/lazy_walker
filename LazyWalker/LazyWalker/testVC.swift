//
//  testVC.swift
//  LazyWalker
//
//  Created by Emmet Susslin on 3/9/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

import UIKit
import GooglePlaces





class testVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableDarkView: UIView!
    
    @IBOutlet weak var tableToggleButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    

    let textArray = ["Continue onto Washington Street", "Turn right onto Montgomery Street", "Turn right onto Sacramento Street", "Turn left onto Spring Street", "Turn right onto California Street", "Turn left onto Kearny Street", "Continue onto 3rd Street", "Turn left onto McCovey Cove Promenade", "Finish!"]
    
    let distanceArray = ["57.428", "199.184", "92.77800000000001", "104.423", "53.58", "566.312", "1644.865", "171.237", "0"]
    
    let directionArray = ["0", "2", "2", "-2", "2", "-2", "0", "-2", "4"]
    
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        print("HEIGHT")
        print(screenSize.height)
        print(screenSize.width)
        

        tableView.frame.size.height = screenSize.height

        tableDarkView.layer.cornerRadius = 22.0
    }
    
    
    //// TOGGLE TABLE
    
    @IBAction func toggleTable(_ sender: UIButton) {
        
        //            self.btn1.addGestureRecognizer
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        if tableView.transform == CGAffineTransform.identity {
            
            UIView.animate(withDuration: 0.8, animations: {
                
                self.tableView.center.y = self.view.center.y
//                self.tableDarkView.center.y = self.tableView.frame.height
//                self.tableToggleButton.center.y = (self.view.center.y) - (self.view.center.y - 30)
                
            }) { (true) in
                self.tableToggleButton.transform = CGAffineTransform(rotationAngle: self.radians(degrees: 180.0))

            }
        } else {
            UIView.animate(withDuration: 0.8, animations: {
                
//                self.tableView.center.y = self.view.center.y / 3
//                self.tableDarkView.center.y = (self.view.center.y / 3) - 10
//                self.tableToggleButton.center.y = (self.view.center.y / 3) - 10
//                self.tableView.transform = .identity
//                self.tableToggleButton.transform = .identity
                
            }) { (true) in
                
            }

        }
    }
    
    func radians(degrees: Double) -> CGFloat {
        return CGFloat(degrees * .pi / degrees)
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! directionsCell
        cell.label.text = textArray[indexPath.row]
        cell.distanceLabel.text = distanceArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArray.count
    }
    
    
    
    
 }
    
    
