//
//  SearchLocationViewController.swift
//  EventHub
//
//  Created by Hoan Le on 10/4/15.
//  Copyright © 2015 Eagle-team. All rights reserved.
//

import UIKit

@objc protocol SearchLocationViewControllerDelegate{
    optional func filtersViewControllerUpdateDistanceState(searchLocationViewController: SearchLocationViewController, near: String)
}

class SearchLocationViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

    
    @IBOutlet weak var searchBar: UISearchBar!
   
    @IBOutlet var locationsTableView: UITableView!
    
    var delegate: SearchLocationViewControllerDelegate?
    
    var results: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        locationsTableView.dataSource = self
        locationsTableView.delegate = self
        searchBar.delegate = self
        // Do any additional setup after loading the view.
        print("didload")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onCancelled(sender: AnyObject) {
           self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func onAccepted(sender: AnyObject) {
        
       // let loc = CLLocation(latitude: self.currentSelectedLat, longitude: self.currentSelectedLng)
        let locationSavedObj = PFObject(className: LocalSettings.SettingsClass)
        locationSavedObj.setObject(self.currentSelectedLng, forKey: "useCurrentLocation")
        locationSavedObj.setObject(self.currentSelectedLat, forKey: "currentLat")
        locationSavedObj.setObject(self.currentSelectedCity, forKey: "currentCityName")
        locationSavedObj.pinInBackground()
        self.delegate?.filtersViewControllerUpdateDistanceState!(self, near: self.currentSelectedCity)
        self.navigationController?.popViewControllerAnimated(true)

        /*
        
        locationSavedObj.pinInBackgroundWithBlock({(success: Bool, error: NSError?) -> Void in
            if success {
                print("Pin success!")
                
                
                
            }
            else {
                print("Pin fail")
            }
            
            self.delegate?.filtersViewControllerUpdateDistanceState!(self, near: self.currentSelectedCity)
            self.navigationController?.popViewControllerAnimated(true)
        })
*/
    }
    
    var currentSearchValue: String!
    var currentSelectedCity : String!
    var currentSelectedLng : Double!
    var currentSelectedLat : Double!
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let nearLocation = results[indexPath.row] as! NSDictionary
        let cityName = nearLocation["name"]
        
        if (cityName != nil)
        {
            self.currentSelectedCity = cityName as! String
        }
        else {  self.currentSelectedCity = self.currentSearchValue}
        
        let longitude = nearLocation.valueForKeyPath("location.lng")
        if (longitude != nil)
        {
            let longitudeF = longitude as! Double
            self.currentSelectedLng = longitudeF
        }
        else {  self.currentSelectedLng = 100}

        
        let latitude = nearLocation.valueForKeyPath("location.lat")
        if (latitude != nil)
        {
            let latitudeF = latitude as! Double
            self.currentSelectedLat = latitudeF
        }
        else {  self.currentSelectedLat = 100}

        print("CURRENT CITY \(self.currentSelectedCity) LAT \(self.currentSelectedLat) LONG \(self.currentSelectedLng)")
       

        /*
        
        let loc = CLLocation(latitude: latitudeF, longitude: longitudeF)
        let locationSavedObj = PFObject(className: "LocationObject")
        locationSavedObj.setObject(loc, forKey: "current_location")
        locationSavedObj.pinInBackgroundWithBlock({(success: Bool, error: NSError?) -> Void in
            if success {
                print("Pin success!")
            }
            else {
                print("Pin fail")
            }
        })
        
        delegate?.filtersViewControllerUpdateDistanceState!(self, near: cityName)
        
          self.navigationController?.popViewControllerAnimated(true)
         //dismissViewControllerAnimated(true, completion: nil)
        */
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell") as! LocationCell
        cell.location = results[indexPath.row] as! NSDictionary
        return cell
    }
 
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        //let newText = NSString(string: searchBar.text!).stringByReplacingCharactersInRange(range, withString: text)
        //fetchLocations(newText)
        if (self.messageLabel != nil && (!self.messageLabel.text!.isEmpty)) {
            self.messageLabel.text = ""
            self.locationsTableView.backgroundView = self.messageLabel;
        }
        return true
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
         searchBar.endEditing(true)
        currentSearchValue = searchBar.text!
        fetchLocations(searchBar.text!)
    }
    func showLoading(){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
    }
    var messageLabel : UILabel!
    
    func fetchLocations(near: String = "") {
    
    
    let url = "https://api.foursquare.com/v2/venues/search?client_id=QA1L0Z0ZNA2QVEEDHFPQWK0I5F1DE3GPLSNW4BZEBGJXUCFL&client_secret=W2AOE1TYC4MHK5SZYOUGX0J3LVRALMPB4CXT3ZH21ZCPUMCU&v=20141020&near=\(near.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)"
    
    let request = NSURLRequest(URL: NSURL(string: url)!)
    
    Utils.showLoading(self.view)
        
    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
        if let data = data {
            
            do {
                if let responseDictionary:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers) as? Dictionary<String, AnyObject> {
                    
                    Utils.hideLoading(self.view)
                    
                    var resultsObject = responseDictionary.valueForKeyPath("response.venues")
                    
                   
                    
                    if resultsObject != nil
                    {
                        self.results =  resultsObject as! NSArray
                        if self.results.count > 0
                        {self.locationsTableView.reloadData()}
                        else
                        {
                            // Display a message when the table is empty
                            self.messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
                            
                            self.messageLabel.text = "No locations found. Please try another keyword!"
                            self.messageLabel.textColor = UIColor.blackColor()
                            self.messageLabel.numberOfLines = 0
                            self.messageLabel.textAlignment = NSTextAlignment.Center
                            //messageLabel.font = UIFont(name: "Palatino-Italic", size: 20)
                            
                            self.messageLabel.sizeToFit()
                            
                            self.locationsTableView.backgroundView = self.messageLabel;
                            //self.locationsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
                        }
                    }
                    else
                    {
                        // Display a message when the table is empty
                        self.messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
                        
                        self.messageLabel.text = "No locations found. Please try another keyword!"
                        self.messageLabel.textColor = UIColor.blackColor()
                        self.messageLabel.numberOfLines = 0
                        self.messageLabel.textAlignment = NSTextAlignment.Center
                        //messageLabel.font = UIFont(name: "Palatino-Italic", size: 20)
                        
                        self.messageLabel.sizeToFit()
                        
                        self.locationsTableView.backgroundView = self.messageLabel;
                        //self.locationsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
                    }
                    
                    
                    
                } else {
                    print("Failed...")
                }
            } catch let serializationError as NSError {
                print(serializationError)
            }
            
        }
    }
}

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return results.count
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
