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
