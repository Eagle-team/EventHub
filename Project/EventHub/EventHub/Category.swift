//
//  Category.swift
//  EventHub
//
//  Created by Anh Nguyen on 9/26/15.
//  Copyright © 2015 Eagle-team. All rights reserved.
//
//
//  Event.swift
//  EventHub
//
//  Created by Anh Nguyen on 9/25/15.
//  Copyright (c) 2015 Eagle-team. All rights reserved.
//

// API
// api.eventful.com/json/category/list ...param app_key

import UIKit

class Category: NSObject {
    
    let name: String?
    let id: String?
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        id = dictionary["id"] as? String
        
    }
    
    class func getCategories(array array: [NSDictionary]) -> [Category] {
        var  allCategories = [Category]()
        for item in array {
            let category = Category(dictionary: item)
            allCategories.append(category)
        }
        return allCategories
    }
    
    
    class func getAllCategories(completion: ([Category]!, NSError!) -> Void) {
        
        EventClient.sharedInstance.getAllCategories(completion)
        
    }
    
}


