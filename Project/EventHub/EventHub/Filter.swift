//
//  Filter.swift
//  SwitchNavDynamic
//
//  Created by datdn1 on 9/27/15.
//  Copyright (c) 2015 datdn1. All rights reserved.
//

import UIKit

// To identfy filter section on Filter screen
enum FilterSectionType:Int {
    case SingleChoose = 0
    case MultiChoose = 1
}

// Define a item in list of filter section
struct ItemInSection {
    var title:String?       // title to display
    var parameterValue:AnyObject?   // value for query when selected
    var selected:Bool?              // identify item whether selected
    
    init(title:String, parameterValue:AnyObject, selected:Bool = false) {
        self.title = title
        self.parameterValue = parameterValue
        self.selected = selected
    }
}

// Define a filter section in Filter screen
class FilterSection : NSObject {
    var titleHeader:String?
    var itemsInSection:[ItemInSection]?
    var filterSectionType:FilterSectionType?
    var parameterFilterName:String?
    var expanded:Bool?
    
    init(titleHeader:String, parameterFilterName:String, itemsInSection:[ItemInSection],filterSectionType:FilterSectionType, expanded:Bool = false){
        self.titleHeader = titleHeader
        self.itemsInSection = itemsInSection
        self.filterSectionType = filterSectionType
        self.parameterFilterName = parameterFilterName
        self.expanded = expanded
    }
    
    var selectedItemIndex:Int{
        get{
            for var item = 0; item < self.itemsInSection?.count; item++ {
                if self.itemsInSection![item].selected!{
                    return item
                }
            }
            return -1
        }
        set{
            // reset current selected item when user select other item
            if self.filterSectionType == .SingleChoose {
                self.itemsInSection![self.selectedItemIndex].selected = false
            }
            // set new item
            self.itemsInSection![newValue].selected = true
        }
    }
    
    // get all selected items in a filter section
    var selectedItems:[ItemInSection]{
        get{
            var items = [ItemInSection]()
            for item in self.itemsInSection! {
                if item.selected! {
                    items.append(item)
                }
            }
            return items
        }
    }
}


