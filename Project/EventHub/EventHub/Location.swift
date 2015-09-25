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

class Location: NSObject {
    
    let countryName: String? // "country_name": "Viet Nam",
                             //"location_type": "region_id",
   // let locationId: String? //"location_id": "3329",

    let locationName: String? //"pretty_name": "Ho Chi Minh, thanh pho",
    //let locationMetaName: String? //"meta_name": "Ho Chi Minh, thanh pho",

    //"country_id": "233",
    //et cityName: String?
    //let countryName: String?
    //let imageURL: NSURL?
    //let startTime: String?
    
    
    init(dictionary: NSDictionary) {
        countryName = dictionary["country_name"] as? String
        locationName = dictionary["meta_name"] as? String
        
    }
    
    class func getLocations(#array: [NSDictionary]) -> [Location] {
        var  allLocations = [Location]()
        for dictionary in array {
            var location = Location(dictionary: dictionary)
            allLocations.append(location)
        }
        return allLocations
    }
    
    
    class func getCurrentLocation(completion: (Location!, NSError!) -> Void) {
        
        EventClient.sharedInstance.suggestCurrentLocation(completion);

    }
    
    class func searchWithTerm(term: String, sort: EventSortMode?, categories: [String]?, deals: Bool?, completion: ([Event]!, NSError!) -> Void) -> Void {
        EventClient.sharedInstance.searchWithTerm(term, sort: sort,categories: categories, deals: deals, completion: completion)
    }
    
}

