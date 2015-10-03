//
//  EventCell.swift
//  EventHub
//
//  Created by Anh Nguyen on 9/25/15.
//  Copyright (c) 2015 Eagle-team. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell, ScaleTableViewTransform {
   
    let miniumScale:CGFloat = 0.1;

    @IBOutlet weak var scaleView: UIView!
    var event: Event! {
        didSet {
            
            eventTitle.text = event.title
            if event.imageURL != nil {
                eventPoster.setImageWithURL(event.imageURL!)
            }
            else
            {
                
                EventClient.sharedInstance.getEventDetail(event.ID!, completion: { (detail, error) -> Void in
                    if ( error == nil )
                    {

                        let category = detail.category
                        
                        let baseUrl =  "http://s1.evcdn.com/images/thumb/fallback/event/categories/"
                        let baseFileName1 = "_default_1.jpg"
                    
                        let slash = "/"
                        
                        let url1 = "\(baseUrl)\(category!)\(slash)\(category!)\(baseFileName1)"
                        
                        self.eventPoster.setImageWithURL(NSURL(string: url1)!)



                    }
                    else
                    {
                        self.eventPoster.setImageWithURL(NSURL(string: "http://s1.evcdn.com/images/edpborder300/fallback/event/categories/other/other_default_1.jpg"))
                    }
                })
            }
            
            eventAddress.text = event.address
            eventCity.text = event.cityName
            //reviewCountLabel.text = "\(business.reviewCount!) Reviews"
            eventTime.text = event.startTime //.setImageWithURL(business.ratingImageURL)
           // distanceLabel.text = business.distance
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse();
        eventPoster.image = nil
        self.scaleView.transform = CGAffineTransformMakeScale(self.miniumScale, self.miniumScale);
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
    
    
    func transformCell(forScale scale: CGFloat) {
        self.scaleView.transform = CGAffineTransformMakeScale(1.0 - scale, 1.0 - scale);
    }

}
