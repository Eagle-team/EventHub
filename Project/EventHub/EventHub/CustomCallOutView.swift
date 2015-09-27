//
//  CustomCallOutView.swift
//  EventHub
//
//  Created by Hoan Le on 9/28/15.
//  Copyright © 2015 Eagle-team. All rights reserved.
//

import UIKit

class CustomCallOutView: UIView {
    
    
    
    var view: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.mainScreen().bounds
        self.view = NSBundle.mainBundle().loadNibNamed("customAnnotation", owner: self, options: nil).first as! UIView
        self.view.frame = UIScreen.mainScreen().bounds
        self.addSubview(self.view)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
