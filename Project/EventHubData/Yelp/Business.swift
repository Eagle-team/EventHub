//
//  Business.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class Business: NSObject {
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
    
    class func businesses(#array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            var business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }
    
    
    class func searchWithLocation(location: String, completion: ([Business]!, NSError!) -> Void) {
        YelpClient.sharedInstance.searchWithTerm(location, completion: completion)
    }
    
    class func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: ([Business]!, NSError!) -> Void) -> Void {
        YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, deals: deals, completion: completion)
    }
    
}
