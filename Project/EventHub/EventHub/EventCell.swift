//
//  EventCell.swift
//  EventHub
//
//  Created by Anh Nguyen on 9/25/15.
//  Copyright (c) 2015 Eagle-team. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    var event: Event! {
        didSet {
            
            eventTitle.text = event.title
            if event.imageURL != nil {
                print("1 \(event.imageURL!)")
                eventPoster.setImageWithURL(event.imageURL!)
           }
            eventAddress.text = event.address
            eventCity.text = event.cityName
            //reviewCountLabel.text = "\(business.reviewCount!) Reviews"
            eventTime.text = event.startTime //.setImageWithURL(business.ratingImageURL)
           // distanceLabel.text = business.distance
        }
    }

    @IBOutlet weak var eventTitle: UILabel!
    
    @IBOutlet weak var eventTime: UILabel!
    
    @IBOutlet weak var eventAddress: UILabel!
    
    @IBOutlet weak var eventCity: UILabel!
    
    @IBOutlet weak var eventPoster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
