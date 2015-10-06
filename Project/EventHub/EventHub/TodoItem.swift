//
//  TodoItem.swift
//  EventHub
//
//  Created by Anh Nguyen on 10/6/15.
//  Copyright © 2015 Eagle-team. All rights reserved.
//

import Foundation


import Foundation

struct TodoItem {
    var title: String
    var deadline: NSDate
    var UUID: String
    
    init(deadline: NSDate, title: String, UUID: String) {
        self.deadline = deadline
        self.title = title
        self.UUID = UUID
    }
    
    var isOverdue: Bool {
        return (NSDate().compare(self.deadline) == NSComparisonResult.OrderedDescending) // deadline is earlier than current date
    }
}