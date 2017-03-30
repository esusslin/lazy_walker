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
        
        
        tableView.backgroundColor = .black
        tableView.backgroundView?.alpha = 0.5
        
        
        tableView.frame.size.height = screenSize.height
        tableView.center.y = view.center.y + 500
        
        print(tableView.frame.size.height)
        
        tableDarkView.center.y = tableView.center.y - 360
        tableToggleButton.center.y = tableView.center.y - 360
        
        print(tableDarkView.center.y)
        
        

        tableDarkView.layer.cornerRadius = 22.0
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
        
        //            self.btn1.addGestureRecognizer
        
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
        print(directionArray)
        
        if directionArray[indexPath.row] == "-3" || directionArray[indexPath.row] == "-2" {
            cell.arrowPic.image = UIImage.init(named: "left")
            
        }
        
        if directionArray[indexPath.row] == "-1" {
            cell.arrowPic.image = UIImage.init(named: "slight-left")
            
        }
        if directionArray[indexPath.row] == "0" {
            cell.arrowPic.image = UIImage.init(named: "straight")
            
        }
        if directionArray[indexPath.row] == "1" {
            cell.arrowPic.image = UIImage.init(named: "slight-right")
            
        }
        
        if directionArray[indexPath.row] == "2" || directionArray[indexPath.row] == "3" {
            cell.arrowPic.image = UIImage.init(named: "right")
            
        }
        
        if directionArray[indexPath.row] == "6"  {
            cell.arrowPic.image = UIImage.init(named: "round")
            
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArray.count
    }
    
    
    
    
 }
    
    
