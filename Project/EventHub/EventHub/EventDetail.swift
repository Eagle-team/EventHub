//
//  EventDetail.swift
//  EventHub
//
//  Created by Anh Nguyen on 9/28/15.
//  Copyright © 2015 Eagle-team. All rights reserved.
//

//
//  Event.swift
//  EventHub
//
//  Created by Anh Nguyen on 9/25/15.
//  Copyright (c) 2015 Eagle-team. All rights reserved.
//


// List of api

// To get suggestion locations
// http://eventful.com/json/tools/location/typedown?location=ho+chi+minh&destination_key=results&recent=1&bubble_up=1&region_id=&location_type=&exclude=

// to get current location
//http://eventful.com/json/tools/location/

import UIKit

class EventDetail: NSObject {
    let title: String?
    let address: String?
    
    let cityName: String?
    let countryName: String?

    let startTime: String?
    
    
    // for simple processing, let load detail event into event
    let detailImageURLs : [NSURL]?
    let detailTicketLinkURLS : [NSURL]?
    //let detailCategories : [String]?
    
    
    init(dictionary: NSDictionary) {
        
        title = dictionary["title"] as? String
        address = dictionary["venue_address"] as? String
        
    
        
        
        cityName = dictionary["city_name"] as? String
        countryName = dictionary["country_name"] as? String
        
        
        startTime = dictionary["start_time"] as? String
        
        //detail
        let allImages = dictionary.valueForKeyPath("images.image") as? [NSDictionary]
        
        if (allImages != nil && allImages?.count > 0)
        {
            var urls : [NSURL] = []
            for image in allImages!
            {
                if image.valueForKeyPath("thumb.url") != nil
                {
                    let url = image.valueForKeyPath("thumb.url") as? String
                    urls.append(NSURL(string: url!)!)
                }
            }
            
            detailImageURLs = urls
        }
        else {detailImageURLs = nil}
        
        
        //detail
        let allLinks = dictionary.valueForKeyPath("links.link") as? [NSDictionary]
        
        if (allLinks != nil && allLinks?.count > 0)
        {
            var links : [NSURL] = []
            for link in allLinks!
            {
                if link.valueForKeyPath("url") != nil
                {
                    let url = link.valueForKeyPath("url") as? String
                    links.append(NSURL(string: url!)!)
                }
            }
            
            detailTicketLinkURLS = links
        }
        else {detailTicketLinkURLS = nil}
    }
  
    class func parseEventDetail(detail: NSDictionary) -> EventDetail {
        return EventDetail(dictionary: detail)
    }
    
    class func fetchEventDetail(id: String, completion: (EventDetail!, NSError!)-> Void)
    {
        EventClient.sharedInstance.getEventDetail(id, completion: completion)
    }
}


