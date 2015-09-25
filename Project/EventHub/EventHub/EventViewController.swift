//
//  EventViewController.swift
//  EventHub
//
//  Created by Anh Nguyen on 9/25/15.
//  Copyright (c) 2015 Eagle-team. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var eventTableView: UITableView!
    
    var events: [Event]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventTableView.dataSource = self
        eventTableView.delegate = self
        eventTableView.rowHeight = UITableViewAutomaticDimension
        eventTableView.estimatedRowHeight = 120
        
        
        Event.searchWithBaseLocation("Ho Chi Minh City", completion: { (events, error) -> Void in
            self.events = events
            self.eventTableView.reloadData()
            
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
