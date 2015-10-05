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


struct DataKeys {
    //location settings
    static let IsUsedCurrentLocation = "IsUsedCurrentLocation"
    static let Address = "Address"
    static let Longitude = "Longitude"
    static let Latitude = "Latitude"
    
    
    
    
}

class LocalSettings : NSObject
{
 
    
    static func GetLocationSettings()-> UserLocationSettings!
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        var usedCurrentLocation : Bool!
        var address : String!
        var lat : Double!
        var lng: Double!
        
        usedCurrentLocation = defaults.boolForKey(DataKeys.IsUsedCurrentLocation)
        address = defaults.stringForKey(DataKeys.Address)
        lat = defaults.doubleForKey(DataKeys.Latitude)
        lng = defaults.doubleForKey(DataKeys.Longitude)
        
        
        defaults.synchronize()
        if (address == nil || lat == nil || lng == nil || usedCurrentLocation == nil)
        {
            return nil
        }else{
        return
            UserLocationSettings(useCurrent: usedCurrentLocation, address: address, lat: lat, lng: lng)

        }
    }
    
    static func SaveLocationSettings(settings : UserLocationSettings)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setBool(settings.useCurrentLocation, forKey: DataKeys.IsUsedCurrentLocation)
        defaults.setValue(settings.addressName, forKey: DataKeys.Address)
        defaults.setDouble(settings.latitude, forKey: DataKeys.Latitude)
        defaults.setDouble(settings.longitude, forKey: DataKeys.Longitude)
        
        defaults.synchronize()

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
