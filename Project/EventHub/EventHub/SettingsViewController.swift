//
//  SettingsViewController.swift
//  EventHub
//
//  Created by Hoan Le on 10/4/15.
//  Copyright © 2015 Eagle-team. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, SearchLocationViewControllerDelegate{


 
    
    @IBOutlet weak var remindTimeSegment: UISegmentedControl!
    
    @IBOutlet weak var changeLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var cityName: UILabel!

    @IBAction func onTouchChangeLocation(sender: AnyObject) {
        let searchLocationVc = storyboard?.instantiateViewControllerWithIdentifier("SearchLocationViewController")  as! SearchLocationViewController
        searchLocationVc.delegate = self
        self.presentViewController(searchLocationVc, animated: true, completion: nil)
        
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func filtersViewControllerUpdateDistanceState(searchLocationViewController: SearchLocationViewController, near: String){
        
        cityName.text = near
       
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
