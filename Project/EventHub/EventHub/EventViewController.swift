//
//  EventViewController.swift
//  EventHub
//
//  Created by Anh Nguyen on 9/25/15.
//  Copyright (c) 2015 Eagle-team. All rights reserved.
//

import UIKit
import CoreLocation

class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FilterViewControllerDelegate {

    @IBOutlet weak var eventTableView: UITableView!
    var location: CLLocation?
    var events: [Event]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("locationLat \(location?.coordinate.latitude)")
        print("locationLng \(location?.coordinate.longitude)")
        
        
        eventTableView.dataSource = self
        eventTableView.delegate = self
        eventTableView.rowHeight = UITableViewAutomaticDimension
        eventTableView.estimatedRowHeight = 120
        
        Utils.showLoading(self.view)
        
        let locationCoordinate = "\(location!.coordinate.latitude),\(location!.coordinate.longitude)"
        
        
        Event.searchWithBaseLocation(locationCoordinate, completion: { (events, error) -> Void in
            Utils.hideLoading(self.view)
            self.events = events
            self.eventTableView.reloadData()
            
        })
        /*
        Category.getAllCategories { (categories, error) -> Void in
            if categories != nil
            {
   
                print(categories)
                
            }
        }
        */
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showLoading(){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if events != nil {
            return events.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventCell
        
        cell.event = events[indexPath.row]        
        return cell
    }


    // Search click handler
    @IBAction func onSearch(sender: UIBarButtonItem) {
        showSearchUI(true)
    }
    
    // update navigation bar
    func showSearchUI(showSearchUI:Bool) {
        if showSearchUI {
            // clear search button bar
            self.navigationItem.rightBarButtonItem = nil
            
            // create filter button
            let filterButton = UIButton(frame: CGRectMake(0, 0, 25, 25))
            filterButton.setBackgroundImage(UIImage(named: "Filter"), forState: .Normal)
            filterButton.addTarget(self, action: "onFilterClick:", forControlEvents: UIControlEvents.TouchUpInside)
            
            let filter = UIBarButtonItem(customView: filterButton)
            self.navigationItem.leftBarButtonItem = filter
            
            // create search bar
            let searchBar = UISearchBar()
            searchBar.placeholder = "Music, Events ..."
            searchBar.showsCancelButton = true
            
            // enable cancel button on search bar
            enableCancelSearchBar(searchBar)
            
            searchBar.delegate = self
            self.navigationItem.titleView = searchBar
        }
        else {
            // clear search ui on navigation bar
            self.navigationItem.titleView = nil
            self.navigationItem.leftBarButtonItem = nil
            
            let searchBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "onSearch:")
            self.navigationItem.rightBarButtonItem = searchBarButton
        }
    }
    
    // enable Cancel button when display
    func enableCancelSearchBar(searchBar:UISearchBar) {
        for containerView in searchBar.subviews {
            for view in containerView.subviews {
                if view.isKindOfClass(UIButton) {
                    let cancelButton = view as! UIButton
                    cancelButton.enabled = true
                    cancelButton.userInteractionEnabled = true
                }
            }
        }
    }
    
    // cancel button handler of search bar
    func searchBarCancelButtonClicked(searchBar: UISearchBar) { // called when cancel button
        showSearchUI(false)
    }
    
    func onFilterClick(sender:UIButton) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let filterVc = mainStoryBoard.instantiateViewControllerWithIdentifier("FilterVC") as? UINavigationController
        let filterViewController = filterVc?.topViewController as! FilterViewController
        filterViewController.delegate = self
        self.presentViewController(filterVc!, animated: true, completion: nil)
    }
    
    // implement protocol of FilterViewController
    func filterViewController(filterViewController:FilterViewController?, didUpdateFilters filters:[String:AnyObject]) {
        print(filters)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = eventTableView.indexPathForCell(cell)!
        
        let event = events![indexPath.row]
        
        let eventDetailsController = segue.destinationViewController as! EventDetailsViewController
        eventDetailsController.event = event

    }
    

}
