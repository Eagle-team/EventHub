//
//  Utils.swift
//  EventHub
//
//  Created by Hoan Le on 9/28/15.
//  Copyright © 2015 Eagle-team. All rights reserved.
//

import UIKit

class Utils: NSObject {
    class func showLoading(view: UIView){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
    }
    
    class func hideLoading(view: UIView){
        MBProgressHUD.hideAllHUDsForView(view, animated: true)
    }
    
    
    
}


class LocalSettings : NSObject
{
    static var SettingsClass : String = "Settings"
    static var enable : String = "UserReminder"
    
    static var userLocationSettings : UserLocationSettings!
    static var userReminderSetting : UserReminderSettings!
    
    static func SaveLocationSettings(settings : UserLocationSettings)
    {
        let query = PFQuery(className: SettingsClass)
        query.fromLocalDatastore()
        query.getObjectInBackgroundWithId("useCurrentLocation").continueWithBlock({
            (task: BFTask!) -> AnyObject! in
            if task.error != nil {
                // There was an error.
                return task
            }
            
            // task.result will be your game score
            return task
        })

    }
}

class UserLocationSettings : NSObject
{
    public var useCurrentLocation : Bool!
    public var addressName : String!
    public var latitude : Double!
    public var longitude : Double!
    
    init(useCurrent : Bool!, address: String!, lat : Double!, lng : Double! )
    {
        super.init()
        self.setData(useCurrent, address: address,  lat: lat,  lng: lng)
    }
    
    public func setData(useCurrent : Bool!, address: String!, lat : Double!, lng : Double! )
    {
        self.useCurrentLocation = useCurrent
        self.addressName = address
        self.latitude = lat
        self.longitude = lng
    }
}

enum RemindTime {
    case ThirdtyMins, AnHour, TwoHours, FourHours
}


class UserReminderSettings : NSObject
{
    public var enabled : Bool!
    public var reminderBefore : RemindTime!
    
    init(isEnabled : Bool!,remindtime : RemindTime! )
    {
        super.init()
        self.setData(isEnabled, remindtime: remindtime)
    }
    
    public func setData(isEnabled : Bool!,remindtime : RemindTime! )
    {
        self.enabled = isEnabled
       self.reminderBefore = remindtime
    }

}
