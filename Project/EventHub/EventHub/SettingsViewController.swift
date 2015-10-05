//
//  SettingsViewController.swift
//  EventHub
//
//  Created by Hoan Le on 10/4/15.
//  Copyright © 2015 Eagle-team. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, SearchLocationViewControllerDelegate, CLLocationManagerDelegate, FBSDKLoginButtonDelegate{


 
    
      let locationManager = CLLocationManager()

    
    @IBOutlet weak var currentLocatoinSwitch: UISwitch!
    
    @IBOutlet weak var changeLocationCell: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
               // Do any additional setup after loading the view.
       fbButton.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        
        var settings = LocalSettings.GetLocationSettings()
        if (settings != nil)
        {
            currentLocatoinSwitch.setOn(settings.useCurrentLocation, animated: true)
            changeLocationCell.hidden = settings.useCurrentLocation
            cityName.text = settings.addressName
            
        }
        
    }
    @IBOutlet weak var fbButton: FBSDKLoginButton!
    
    @IBAction func onSwitchLocationChanged(sender: UISwitch) {
      
        Utils.showLoading(self.view)
        changeLocationCell.hidden = sender.on
        var currentSettings = LocalSettings.GetLocationSettings()
        if (currentSettings == nil)
        {
            Utils.hideLoading(self.view)
        }
        else
        {
            currentSettings.useCurrentLocation = sender.on
            
            if (sender.on)
            {
                
                LocalSettings.SaveLocationSettings(currentSettings)
                getLocation()
            }
            else
            {
                LocalSettings.SaveLocationSettings(currentSettings)
                cityName.text = currentSettings.addressName
                Utils.hideLoading(self.view)
            }
          
        }
    }
   
    
    
    
    func getLocation(){
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
        
    }
    var a = 0
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (a == 0){
            a = a + 1
            //manager.stopUpdatingLocation()
            let locationSettings = UserLocationSettings(useCurrent: true, address: "Ho Chi Minh City", lat: manager.location!.coordinate.latitude, lng: manager.location!.coordinate.longitude)
            LocalSettings.SaveLocationSettings(locationSettings)
            
            Utils.hideLoading(self.view)
        }
    }

   
    @IBOutlet weak var cityName: UILabel!

   
  
  
    @IBAction func onTouchChangeLocation(sender: AnyObject) {
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
               let settingVCNavigator = mainStoryBoard.instantiateViewControllerWithIdentifier("SearchNavigationVC") as? UINavigationController
        let searchCityVC = settingVCNavigator?.viewControllers[0] as! SearchLocationViewController
        searchCityVC.delegate = self
        
        self.navigationController?.pushViewController(searchCityVC, animated: true)
        /*

        let searchLocationVc = mainStoryBoard.instantiateViewControllerWithIdentifier("SearchLocationViewController")  as! SearchLocationViewController
        searchLocationVc.delegate = self
        self.presentViewController(searchLocationVc, animated: true, completion: nil)
 */

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        print("User Logged In")
        
        if ((error) != nil)
        {
            print("error")
        }
        else if result.isCancelled
        {
            print("cancel")
        }
        else {
            getLocation()
        }
    }
    
    /*!
    @abstract Sent to the delegate when the button was used to logout.
    @param loginButton The button that was clicked.
    */
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        self.navigationController?.popViewControllerAnimated(true)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewController") as UIViewController
        //self.presentViewController(vc, animated: true, completion: nil)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.setRootViewController(vc)
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    
    func filtersViewControllerUpdateDistanceState(searchLocationViewController: SearchLocationViewController, near: String){
        cityName.text = near
        /*
        
        */
        /*
        let query = PFQuery(className: LocalSettings.SettingsClass)
        query.fromLocalDatastore()
        query.getObjectInBackgroundWithId("currentCityName").continueWithBlock {
            (task: BFTask!) -> AnyObject in
            if let error = task.error {
                // Something went wrong.
                return task;
            }
            
            // task.result will be your game score
            var valueD = task.valueForKey( "currentCityName") as! String
            print(valueD)
            return task;
        }*/
    }
    

    
    // MARK: - Table view data source
    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
