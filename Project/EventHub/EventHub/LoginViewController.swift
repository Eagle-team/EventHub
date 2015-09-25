//
//  LoginViewController.swift
//  EventHub
//
//  Created by Anh Nguyen on 9/19/15.
//  Copyright (c) 2015 Eagle-team. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
             var timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("ChangeView"), userInfo: nil, repeats: false)
            
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends", "user_location"]
            loginView.delegate = self
        }
    }
    
   
    
    func ChangeView() {
        // Something after a delay
        
        let setlocationVC = self.storyboard?.instantiateViewControllerWithIdentifier("SetLocationViewController") as? SetLocationViewController
        
        self.navigationController?.pushViewController(setlocationVC!, animated: true)
        
        self.presentViewController(setlocationVC!, animated: true, completion: nil)
        self.showViewController(setlocationVC!, sender: self)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        println("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
            
            let setlocationVC = self.storyboard?.instantiateViewControllerWithIdentifier("SetLocationViewController") as? SetLocationViewController
            
            self.navigationController?.pushViewController(setlocationVC!, animated: true)
            self.presentViewController(setlocationVC!, animated: true, completion: nil)
        }
    }
    
    /*!
    @abstract Sent to the delegate when the button was used to logout.
    @param loginButton The button that was clicked.
    */
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        println("User Logged Out")
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
