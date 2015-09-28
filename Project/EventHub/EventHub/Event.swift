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

class Event: NSObject {
    let title: String?
    let address: String?
    
    let cityName: String?
    let countryName: String?
    let imageURL: NSURL?
    let startTime: String?
    
    let ID: String?

    
    
    init(dictionary: NSDictionary) {
        
        title = dictionary["title"] as? String
        address = dictionary["venue_address"] as? String
        ID = dictionary["id"] as? String
        
        let url = dictionary.valueForKeyPath("image.medium.url") as? String
        
        
        if  url != nil
        {
            print(url)
            imageURL = NSURL(string: url!)
        }
        else {
            imageURL = nil
        }
        
        cityName = dictionary["city_name"] as? String
        countryName = dictionary["country_name"] as? String
        
        
        startTime = dictionary["start_time"] as? String

    }
    
    class func allEvents(array array: [NSDictionary]) -> [Event] {
        var  events = [Event]()
        for dictionary in array {
            let anEvent = Event(dictionary: dictionary)
            events.append(anEvent)
        }
        return events
    }
    

    
    class func searchWithBaseLocation(location: String, completion: ([Event]!, NSError!) -> Void) {
        EventClient.sharedInstance.searchWithBaseLocation(location, completion: completion)
    }
    
    
    class func searchWithTerm(term: String, sort: EventSortMode?, categories: [String]?, deals: Bool?, completion: ([Event]!, NSError!) -> Void) -> Void {
        EventClient.sharedInstance.searchWithTerm(term, sort: sort,categories: categories, deals: deals, completion: completion)
    }
    
}

