//
//  Event.swift
//  EventHub
//
//  Created by Anh Nguyen on 9/25/15.
//  Copyright (c) 2015 Eagle-team. All rights reserved.
//

import UIKit

class Event: NSObject {
    let title: String?
    let address: String?
    //et cityName: String?
    //let countryName: String?
    //let imageURL: NSURL?
    //let startTime: String?
    
    
    init(dictionary: NSDictionary) {
        title = dictionary["title"] as? String
        address = dictionary["venue_address"] as? String
        
    }
    
    class func allEvents(#array: [NSDictionary]) -> [Event] {
        var  events = [Event]()
        for dictionary in array {
            var anEvent = Event(dictionary: dictionary)
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

