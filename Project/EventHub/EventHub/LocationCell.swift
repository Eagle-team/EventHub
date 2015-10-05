//
//  LocationCell.swift
//  EventHub
//
//  Created by Hoan Le on 10/4/15.
//  Copyright © 2015 Eagle-team. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    
    
    
    
    @IBOutlet weak var cityName: UILabel!
    var location: NSDictionary! {
        didSet {
            cityName.text = location["name"] as? String
            /*
            addressLabel.text = location.valueForKeyPath("location.address") as? String
            
            let categories = location["categories"] as? NSArray
            if (categories != nil && categories!.count > 0) {
                let category = categories![0] as! NSDictionary
                let urlPrefix = category.valueForKeyPath("icon.prefix") as! String
                let urlSuffix = category.valueForKeyPath("icon.suffix") as! String
                
                let url = "\(urlPrefix)bg_32\(urlSuffix)"
                categoryImageView.setImageWithURL(NSURL(string: url))
            }*/
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
