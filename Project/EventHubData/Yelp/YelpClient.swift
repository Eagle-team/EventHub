//
//  YelpClient.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

// You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
let yelpConsumerKey = "2a9b64c7b372deb628fc"
let yelpConsumerSecret = "115f9b6c6f32a714a003"
//let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
//let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"

enum YelpSortMode: Int {
    case BestMatched = 0, Distance, HighestRated
}

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    class var sharedInstance : YelpClient {
        struct Static {
            static var token : dispatch_once_t = 0
            static var instance : YelpClient? = nil
        }
        
        dispatch_once(&Static.token) {
            Static.instance = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret)//, accessToken: "", accessSecret: :""!)
        }
        return Static.instance!
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!){//, accessToken: String!, accessSecret: String!) {
       // self.accessToken = accessToken
       // self.accessSecret = accessSecret
        var baseUrl = NSURL(string: "http://api.eventful.com/json/events/search")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        //var token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        //self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(location: String, completion: ([Business]!, NSError!) -> Void) -> AFHTTPRequestOperation {
        return searchWithTerm(location, sort: nil, categories: nil, deals: nil, completion: completion)
    }
    
    func searchWithTerm(location: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: ([Business]!, NSError!) -> Void) -> AFHTTPRequestOperation {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api

        // Default the location to San Francisco
        var parameters: [String : AnyObject] = ["app_key": "dBBqWtxNzNgKWx3P","location": location, "date": "Future", "oauth_consumer_key":"2a9b64c7b372deb628fc", "oauth_signature_method":"HMAC-SHA1"]
        
        //oauth_consumer_key=2a9b64c7b372deb628fc&oauth_signature_method=HMAC-SHA1
    
        if sort != nil {
            parameters["sort"] = sort!.rawValue
        }
        
        if categories != nil && categories!.count > 0 {
            parameters["category_filter"] = ",".join(categories!)
        }
        
        if deals != nil {
            parameters["deals_filter"] = deals!
        }
        
        println(parameters)
        
        return self.GET("", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println(response["events"]);
              //println(response["events.event"]);
             // println(response["event"]);
            var dictionarie = response["events"]! as? NSDictionary
            var dictionaries = dictionarie?["event"] as? [NSDictionary]
            if dictionaries != nil {

                completion(Business.businesses(array: dictionaries!), nil)
            }
            }, failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(nil, error)
        })
    }
}
