//
//  LoginViewController.swift
//  EventHub
//
//  Created by Anh Nguyen on 9/19/15.
//  Copyright (c) 2015 Eagle-team. All rights reserved.
//

import UIKit
import CoreLocation
//import MBProgessHUD


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("============================================")
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        self.view.addSubview(loginView)
        loginView.center = self.view.center
        loginView.readPermissions = ["public_profile", "email", "user_friends", "user_location"]
        loginView.delegate = self
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            getLocation()
        }
    }
    
    func showLoading(){
        //let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //loadingNotification.mode = MBProgressHUDMode.Indeterminate
        //loadingNotification.labelText = "Loading"
    }
    
    func getLocation(){
        showLoading()
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
            goToLanding(manager.location!)
        }
    }
    
    func ChangeView() {
        return;
        // Something after a delay
        
        let setlocationVC = self.storyboard?.instantiateViewControllerWithIdentifier("EventViewController") as? SetLocationViewController
        
        self.navigationController?.pushViewController(setlocationVC!, animated: true)
        
        self.presentViewController(setlocationVC!, animated: true, completion: nil)
        self.showViewController(setlocationVC!, sender: self)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToLanding (location: CLLocation){
        
        let setlocationVC = self.storyboard?.instantiateViewControllerWithIdentifier("EventViewController") as? EventViewController
        setlocationVC?.location = location
        self.navigationController?.pushViewController(setlocationVC!, animated: true)
        self.presentViewController(setlocationVC!, animated: true, completion: nil)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        print("User Logged In")
        
        if ((error) != nil)
        {
            print("error")   
        }
        else if result.isCancelled {
            print("cancel")
        }
        else {
             getLocation()
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    
    /*!
    @abstract Sent to the delegate when the button was used to logout.
    @param loginButton The button that was clicked.
    */
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        print("User Logged Out")
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
