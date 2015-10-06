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
    static var events: [Event]!
    
    static var eventResponseHeader = EventResponeHeader()
    
    var isLoading:Bool!
    var term:String!
    
    var params:[String:AnyObject]?
    
    // offset 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("locationLat \(location?.coordinate.latitude)")
        print("locationLng \(location?.coordinate.longitude)")
        
        // set loading
        isLoading = false
//        self.events = []
        
        eventTableView.dataSource = self
        eventTableView.delegate = self
        eventTableView.rowHeight = UITableViewAutomaticDimension
        eventTableView.estimatedRowHeight = 250
        
//        Utils.showLoading(self.view)
        
//        let locationCoordinate = "\(location!.coordinate.latitude),\(location!.coordinate.longitude)"
//        
//        
//        // get events when launch event view controller
//        Event.searchWithBaseLocation(locationCoordinate, completion: { (events, error) -> Void in
//            Utils.hideLoading(self.view)
//            self.events = events
//            self.eventTableView.reloadData()
//            
//        })
        
        self.eventTableView.infiniteScrollIndicatorStyle = .Gray
        self.eventTableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            self.loadMoreEvents()
            tableView.finishInfiniteScroll()
        }
        loadEvents(false)
    }
    
    func loadMoreEvents() {
        if EventViewController.eventResponseHeader.pageNumber <  EventViewController.eventResponseHeader.pageCount {
            self.isLoading = true
            loadEvents(true)
            print("Page count = \(EventViewController.eventResponseHeader.pageCount)")
            print("Page number = \(EventViewController.eventResponseHeader.pageNumber)")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        var currentSettings = LocalSettings.GetLocationSettings()
        if (currentSettings != nil)
        {
            if (abs(currentSettings.latitude - location!.coordinate.latitude) > 2
            && abs(currentSettings.longitude - location!.coordinate.longitude) > 2)
            {
                location = CLLocation(latitude: currentSettings.latitude, longitude: currentSettings.longitude)
                loadEvents(false)
            }
            
        }
    }
    
    func loadEvents(loading:Bool) {
            // get params to query
        let sortParams = params?["sort_order"] as? String
        let dateParams = params?["date"] as? String
        let distanceParams = params?["within"] as? Int
        let categoriesParams = params?["category"] as? [String]
        let locationCoordinate = "\(location!.coordinate.latitude),\(location!.coordinate.longitude)"
        print("loc \(locationCoordinate)")
        let pageNumber:Int? = (self.isLoading == true ) ? (EventViewController.eventResponseHeader.pageNumber! + 1) : nil
        
            Utils.showLoading(self.view)

        Event.searchWithTerm(locationCoordinate, term: term, date: dateParams, distance: distanceParams, sort: sortParams, categories: categoriesParams, pageNumber: pageNumber) { (events: [Event]!, error: NSError!) -> Void in
            // hide progess bar
            Utils.hideLoading(self.view)
            
            if error == nil {
                // if loading
                if loading {
                    EventViewController.events = EventViewController.events! + events // add new event to event array
                    self.isLoading = false
                    print("Event number when loading = \(EventViewController.events.count)")
                    self.updateTableView()
                    //                        self.even tTableView.reloadData()     // reload table
                }
                    // if the first load or filter changed
                else {
                    
                    EventViewController.events = events
                    print("Event number when not loading = \(EventViewController.events.count)")
                    if EventViewController.events.count == 0 {
                        print("not data to show")
                    }
                    //                        self.eventTableView.
                    self.eventTableView.reloadData()
                }
            }
            else {
                // display error message
            }
        }
//        else {
//            // query event when launch view controller
//            let locationCoordinate = "\(location!.coordinate.latitude),\(location!.coordinate.longitude)"
//            Event.searchWithBaseLocation(locationCoordinate, completion: { (events, error) -> Void in
//                Utils.hideLoading(self.view)
//                self.events = events
//                self.eventTableView.reloadData()
//                
//            })
//            
//            
//    }
    }
    
    func updateTableView() {
        var indexPathArrRowInsert = [NSIndexPath]()
        let offset = 10 * (EventViewController.eventResponseHeader.pageNumber! - 1)
        print("Update row at offset \(offset)-\(EventViewController.events.count-1)")
        for rowToInsert in offset...EventViewController.events.count-1 {
            var indexPathRow = NSIndexPath(forRow: rowToInsert, inSection: 0)
            indexPathArrRowInsert.append(indexPathRow)
        }
        self.eventTableView.beginUpdates()
        self.eventTableView.insertRowsAtIndexPaths(indexPathArrRowInsert, withRowAnimation: UITableViewRowAnimation.Bottom)
        self.eventTableView.endUpdates()
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
        if EventViewController.events != nil {
            return EventViewController.events.count
        } else {
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if EventViewController.events == nil || EventViewController.events.count > 0 {
            self.eventTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine;
            return 1;
        }
        else {
            // Display a message when the table is empty
            let messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
            
            messageLabel.text = "No data is currently available. Please try again."
            messageLabel.textColor = UIColor.blackColor()
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.font = UIFont(name: "Palatino-Italic", size: 20)
            
            messageLabel.sizeToFit()
            
            self.eventTableView.backgroundView = messageLabel;
            self.eventTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventCell
        
        cell.event = EventViewController.events[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
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
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("\(searchBar.text)")
        self.term = searchBar.text
        searchBar.resignFirstResponder()
        loadEvents(false)
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
        params = filters
        loadEvents(false)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = eventTableView.indexPathForCell(cell)!
        
        let event = EventViewController.events![indexPath.row]
        
        let eventDetailsController = segue.destinationViewController as! EventDetailsViewController
        eventDetailsController.event = event

    }
    
    
    

}
