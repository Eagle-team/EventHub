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
    
    @IBOutlet weak var locationsTableView: UITableView!
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
    

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let nearLocation = results[indexPath.row] as! NSDictionary
        var cityName = nearLocation.valueForKeyPath("location.state") as! String ?? "" //as! String
        
        var longitude = nearLocation.valueForKeyPath("location.lat") as! String
        var latitude = nearLocation.valueForKeyPath("location.lng") as! String
        
        let latitudeF: CLLocationDegrees = (longitude as NSString).doubleValue
        let longitudeF: CLLocationDegrees = (latitude as NSString).doubleValue

        
        var loc = CLLocation(latitude: latitudeF, longitude: longitudeF)
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
        
         dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell") as! LocationCell
        cell.location = results[indexPath.row] as! NSDictionary
        return cell
    }

    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newText = NSString(string: searchBar.text!).stringByReplacingCharactersInRange(range, withString: text)
        //fetchLocations(newText)
        return true
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        fetchLocations(searchBar.text!)
    }

func fetchLocations(near: String = "") {
    
    
    var url = "https://api.foursquare.com/v2/venues/search?client_id=QA1L0Z0ZNA2QVEEDHFPQWK0I5F1DE3GPLSNW4BZEBGJXUCFL&client_secret=W2AOE1TYC4MHK5SZYOUGX0J3LVRALMPB4CXT3ZH21ZCPUMCU&v=20141020&near=\(near.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)"
    
    var request = NSURLRequest(URL: NSURL(string: url)!)
    
    
    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
        if let data = data {
            
            do {
                if let responseDictionary:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers) as? Dictionary<String, AnyObject> {
                    self.results = responseDictionary.valueForKeyPath("response.venues") as! NSArray
                    self.locationsTableView.reloadData()
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
