//
//  animations.swift
//  LazyWalker
//
//  Created by Emmet Susslin on 2/25/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

import UIKit

extension mapVC: CAAnimationDelegate {
    
   
    
    // ANIMATIONS:
    
    func animateLaunch(image: UIImage) {
        
        // CREATE AND APPLY MASK
        
        mask = CALayer()
        mask.contents = image.cgImage
        mask.bounds = CGRect(x: 0, y: 0, width: 128, height: 128)
        mask.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        mask.position = CGPoint(x: mapView.frame.width / 2.0, y: mapView.frame.height / 2.0)
        mapView.layer.mask = mask
        
        animateDecreaseSize()
        
    }
    
    func animateDecreaseSize() {
        
        let decreaseSize = CABasicAnimation(keyPath: "bounds")
        decreaseSize.delegate = self
        decreaseSize.duration = 2.0
        decreaseSize.fromValue = NSValue(cgRect: mask!.bounds)
        decreaseSize.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: 20, height: 20))
        
        decreaseSize.fillMode = kCAFillModeForwards
        decreaseSize.isRemovedOnCompletion = false
        
        mask.add(decreaseSize, forKey: "bounds")
  
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animateIncreaseSize()
    }
    
    func animateIncreaseSize() {
        
        animation = CABasicAnimation(keyPath: "bounds")
        animation.duration = 2.0
        animation.fromValue = NSValue(cgRect: mask!.bounds)
        animation.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: 8000, height: 8000))
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        
        mask.add(animation, forKey: "bounds")

        UIView.animate(withDuration: 2.0, animations: {
            self.overlay.alpha = 0
            self.logoImageview.alpha = 0
        }) { (true) in

        }
        
        
    }

}
