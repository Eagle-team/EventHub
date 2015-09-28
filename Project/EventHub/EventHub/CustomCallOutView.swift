//
//  CustomCallOutView.swift
//  EventHub
//
//  Created by Hoan Le on 9/28/15.
//  Copyright © 2015 Eagle-team. All rights reserved.
//

import UIKit

class CustomCallOutView: UIView {
    
    @IBOutlet weak var eventTitleView: UILabel!
    
    @IBOutlet weak var eventAddressLabel: UILabel!
    
    @IBOutlet weak var eventTimeLabel: UILabel!
    
    @IBOutlet weak var favouriteButton: UIButton!
    
    @IBOutlet weak var trackButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    var event: Event?
    
    
    @IBAction func onShare(sender: UIButton) {
        print("share \(event?.title)")
    }
    
    @IBAction func onTrack(sender: UIButton) {
        print("track \(event?.title)")
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        print("favorite \(event?.title)")
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
