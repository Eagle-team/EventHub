//
//  EventClient.swift
//  EventHub
//
//  Created by Anh Nguyen on 9/25/15.
//  Copyright (c) 2015 Eagle-team. All rights reserved.
//

import Foundation


import UIKit

// from eventful.com

let eventfulConsumerKey = "2a9b64c7b372deb628fc"
let eventfulConsumerSecret = "115f9b6c6f32a714a003"
let eventfulAppKey = "dBBqWtxNzNgKWx3P"

let baseAPIUrl = "http://api.eventful.com"
let searchEventApi = "/json/events/search"

let baseNormalAPI = "http://eventful.com/json/tools/location/"
let locationSearchAPI = "/Location/typedown"
let currentLocationAPI = "/Location/"

let allCategoryAPI = "/json/categories/list"
let getEventDetailAPI = "/json/events/get"

enum EventSortMode: Int {
    case Relevance = 0, Date, Popularity, Alphabet, VenueName
}

class EventClient: BDBOAuth1RequestOperationManager {
    
    class var sharedInstance : EventClient {
        struct Static {
            static var token : dispatch_once_t = 0
            static var instance : EventClient? = nil
        }
        
        dispatch_once(&Static.token) {
            Static.instance = EventClient(consumerKey: eventfulConsumerKey, consumerSecret: eventfulConsumerSecret)
        }
        return Static.instance!
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!){
        
        //var baseUrl = NSURL(string: baseNormalAPI)
        let baseUrl = NSURL(string: baseAPIUrl)
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        //var token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        //self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithBaseLocation(location: String, completion: ([Event]!, NSError!) -> Void) -> AFHTTPRequestOperation {
        return searchWithTerm(location, sort: nil, categories: nil, deals: nil, completion: completion)
    }
    
    func suggestCurrentLocation(completion: (Location!, NSError!) -> Void) -> AFHTTPRequestOperation {

       //let getCurrentLocationURL = "eventful.com/json/tools/location"
        //var parameters: [String : AnyObject] = ["app_key": eventfulAppKey]
        return self.GET("", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            //print(response)
            
            let location = response["current"]! as? NSDictionary
            
            if location != nil {
                
                completion(Location(dictionary: location!), nil)
            }
            }, failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(nil, error)
        })

    }
    
    /*
    func searchLocation(key: String, ([Location]!, NSError!) -> Void) -> AFHTTPRequestOperation {
        self.baseURL = baseNormalAPI as NSURL
        
        var parameters: [String : AnyObject] = ["app_key": eventfulAppKey,"location": location, "date": "Future"]
        
        return self.GET(locationSearchAPI, parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println(response["events"]);
            var dictionarie = response["events"]! as? NSDictionary
            var dictionaries = dictionarie?["event"] as? [NSDictionary]
            if dictionaries != nil {
                
                completion(Event.allEvents(array: dictionaries!), nil)
            }
            }, failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(nil, error)
        })
        
    }*/
    
    func searchWithTerm(location: String, sort: EventSortMode?, categories: [String]?, deals: Bool?, completion: ([Event]!, NSError!) -> Void) -> AFHTTPRequestOperation {
        
        
        // Default the location to San Francisco
        var parameters: [String : AnyObject] = ["app_key": eventfulAppKey,"location": location, "date": "Future", "within" : 5]
        //"oauth_consumer_key":"2a9b64c7b372deb628fc", "oauth_signature_method":"HMAC-SHA1"]
        
        //oauth_consumer_key=2a9b64c7b372deb628fc&oauth_signature_method=HMAC-SHA1
        
        
        return self.GET(searchEventApi, parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            print(response["events"])
            let dictionarie = response["events"]! as? NSDictionary
            let dictionaries = dictionarie?["event"] as? [NSDictionary]
            
            if dictionaries != nil {
                
                completion(Event.allEvents(array: dictionaries!), nil)
                
                // get event response header
                let totalItemsOp = response["total_items"] as? String
                let pageNumberOp = response["page_number"] as? String
                let pageCountOp = response["page_count"] as? String
                
                let totalItems =  totalItemsOp == nil ? 0 : Int(totalItemsOp!)
                let pageNumber =  pageNumberOp == nil ? 0 : Int(pageNumberOp!)
                let pageCount =  pageCountOp == nil ? 0 : Int(pageCountOp!)
                
                EventViewController.eventResponseHeader.totalItems = totalItems
                EventViewController.eventResponseHeader.pageNumber = pageNumber
                EventViewController.eventResponseHeader.pageCount = pageCount
            }
            }, failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(nil, error)
        })
    }
    
    // func query events with all params
    func searchWithTerm(location: String, term:String?, date:String?, distance:Int?, sort: String?, categories: [String]?, pageNumber: Int?, completion: ([Event]!, NSError!) -> Void) -> AFHTTPRequestOperation {
        
        var parameters: [String : AnyObject] = ["app_key": eventfulAppKey,"location": location, "date": "Future", "within" : 5]
        
        if term != nil {
            parameters["keywords"] = term
        }
        if date != nil {
            parameters["date"] = date
        }
        if distance != nil {
            parameters["within"] = distance
        }
        if sort != nil {
            parameters["sort_order"] = sort
        }
        if categories != nil && categories!.count > 0 {
            parameters["category"] = (categories!).joinWithSeparator(",")
        }
        if pageNumber != nil {
            parameters["page_number"] = pageNumber
        }
        
        print("All params = \(parameters)")
        
        return self.GET(searchEventApi, parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//            print(response["events"])
            let dictionarie = response["events"]! as? NSDictionary
            let dictionaries = dictionarie?["event"] as? [NSDictionary]
            
            if dictionaries != nil {
                // get event response header
                let totalItemsOp = response["total_items"] as? String
                let pageNumberOp = response["page_number"] as? String
                let pageCountOp = response["page_count"] as? String
                
                let totalItems =  totalItemsOp == nil ? 0 : Int(totalItemsOp!)
                let pageNumber =  pageNumberOp == nil ? 0 : Int(pageNumberOp!)
                let pageCount =  pageCountOp == nil ? 0 : Int(pageCountOp!)
                
                EventViewController.eventResponseHeader.totalItems = totalItems
                EventViewController.eventResponseHeader.pageNumber = pageNumber
                EventViewController.eventResponseHeader.pageCount = pageCount
                
                // callback to update UI when success
                completion(Event.allEvents(array: dictionaries!), nil)
            }
            else {
                // callback when no event returned
                completion(Event.allEvents(array: []), nil)
            }
            }, failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                // callback when fail
                completion(nil, error)
        })
    }

    
    func getAllCategories(completion: ([Category]!, NSError!) -> Void) -> AFHTTPRequestOperation {
        let parameters: [String : AnyObject] = ["app_key": eventfulAppKey]
        return self.GET(allCategoryAPI, parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//            print(response["category"]);
            let dictionaries = response["category"]! as? [NSDictionary]
            
            if dictionaries != nil {
                
                completion(Category.getCategories(array: dictionaries!) , nil)
            }
            }, failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(nil, error)
        })
    }
    
    func getEventDetail(eventId: String, completion:(EventDetail!, NSError!)->Void)-> AFHTTPRequestOperation
    {
        let parameters: [String : AnyObject] = ["app_key": eventfulAppKey, "id": eventId]
        return self.GET(getEventDetailAPI, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, response: AnyObject!) -> Void in

            let eventDetail = response! as? NSDictionary
            
            if eventDetail != nil {
                
                completion(EventDetail.parseEventDetail(eventDetail!) , nil)
            }
            }, failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(nil, error)
        })
    }
}