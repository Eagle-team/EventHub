//
//  SetLocationViewController.swift
//  EventHub
//
//  Created by Anh Nguyen on 9/19/15.
//  Copyright (c) 2015 Eagle-team. All rights reserved.
//

import UIKit

class SetLocationViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Location.getCurrentLocation { (location, error) -> Void in
        //    self.locationTextField.text = location.locationName
        //}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func OnLocationSet(sender: AnyObject) {
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
