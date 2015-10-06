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
    
    var controller: UIViewController!

    var event: Event?
    
    
    @IBAction func onShare(sender: UIButton) {
        print("share \(event?.title)")
        
        let shareContent = FBSDKShareLinkContent()
        shareContent.contentURL = NSURL(string: (event?.eventURL)!)
        
        shareContent.contentTitle = event?.title
        
        FBSDKShareDialog.showFromViewController(controller, withContent: shareContent, delegate: nil)

    }
    
    @IBAction func onTrack(sender: UIButton) {
        print("track \(event?.title)")
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        let query = PFQuery(className:"FavoriteEvent")
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if (objects == nil || objects?.count == 0){
                print("nil or 0")
                let obj = PFObject(className:"FavoriteEvent")
                obj["eventId"] = self.event!.ID!
                obj["eventTitle"] = self.event?.title
                obj["eventAddress"] = self.event?.address
                obj["eventStartTime"] = self.event?.startTime
                
                if self.event!.imageURL != nil {
                    obj["eventUrl"] = self.event!.imageURL?.absoluteString
                }else{
                    obj["eventUrl"] = "http://s1.evcdn.com/images/edpborder300/fallback/event/categories/other/other_default_1.jpg"
                }
               
                obj.pinInBackground()
                
            }else{
                var check = false
                for o in objects!{
                    var oName = o["eventTitle"] as! String
                    print("eventTitle:: \(oName)")
                    var oID = o["eventId"] as! String
                    if (self.event?.ID == oID){
                        o["eventId"] = self.event!.ID!
                        o["eventTitle"] = self.event?.title
                        o["eventAddress"] = self.event?.address
                        o["eventStartTime"] = self.event?.startTime
                        if self.event!.imageURL != nil {
                            o["eventUrl"] = self.event!.imageURL?.absoluteString
                        }else{
                            o["eventUrl"] = "http://s1.evcdn.com/images/edpborder300/fallback/event/categories/other/other_default_1.jpg"
                        }
                        o.saveInBackground()
                        check = true
                    }
                }
                if (check == false){
                    let obj = PFObject(className:"FavoriteEvent")
                    obj["eventId"] = self.event!.ID!
                    obj["eventTitle"] = self.event?.title
                    obj["eventAddress"] = self.event?.address
                    obj["eventStartTime"] = self.event?.startTime
                    if self.event!.imageURL != nil {
                        obj["eventUrl"] = self.event!.imageURL?.absoluteString
                    }else{
                        obj["eventUrl"] = "http://s1.evcdn.com/images/edpborder300/fallback/event/categories/other/other_default_1.jpg"
                    }
                    obj.pinInBackground()
                }
            }
        }
    }
    /*
    @IBAction func onFavorite(sender: AnyObject) {
    let query = PFQuery(className:"FavoriteEvent")
    query.fromLocalDatastore()
    query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
    if (objects == nil || objects?.count == 0){
    print("nil or 0")
    let obj = PFObject(className:"FavoriteEvent")
    obj["eventId"] = self.event!.ID!
    obj["eventTitle"] = self.event?.title
    obj["eventAddress"] = self.event?.address
    obj["eventStartTime"] = self.event?.startTime
    obj.pinInBackground()
    
    }else{
    var check = false
    for o in objects!{
    var oName = o["eventTitle"] as! String
    print("eventTitle:: \(oName)")
    var oID = o["eventId"] as! String
    if (self.event?.ID == oID){
    o["eventId"] = self.event!.ID!
    o["eventTitle"] = self.event?.title
    o["eventAddress"] = self.event?.address
    o["eventStartTime"] = self.event?.startTime
    o.saveInBackground()
    check = true
    }
    }
    if (check == false){
    let obj = PFObject(className:"FavoriteEvent")
    obj["eventId"] = self.event!.ID!
    obj["eventTitle"] = self.event?.title
    obj["eventAddress"] = self.event?.address
    obj["eventStartTime"] = self.event?.startTime
    obj.pinInBackground()
    }
    }
    }
    }
*/
    
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
