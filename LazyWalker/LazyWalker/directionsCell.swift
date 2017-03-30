//
//  TableViewCell.swift
//  LazyWalker
//
//  Created by Emmet Susslin on 3/29/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

import UIKit

class directionsCell: UITableViewCell {
    
    
   
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var arrowPic: UIImageView!

    @IBOutlet weak var distanceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
                label.translatesAutoresizingMaskIntoConstraints = false
                arrowPic.translatesAutoresizingMaskIntoConstraints = false
                distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[arrow(16)]-10-[label]-10-[distance]-5-|",
                    options: [], metrics: nil, views: ["arrow":arrowPic, "label":label,"distance":distanceLabel]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[arrow(16)]-10-|",
                    options: [], metrics: nil, views: ["arrow":arrowPic]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[label]-10-|",
                    options: [], metrics: nil, views: ["label":label]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[distance]-10-|",
                    options: [], metrics: nil, views: ["distance":distanceLabel]))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

