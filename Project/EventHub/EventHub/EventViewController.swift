//
//  EventViewController.swift
//  EventHub
//
//  Created by Anh Nguyen on 9/25/15.
//  Copyright (c) 2015 Eagle-team. All rights reserved.
//

import UIKit
import CoreLocation

class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
