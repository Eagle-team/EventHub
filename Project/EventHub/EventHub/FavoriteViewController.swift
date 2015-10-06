//
//  FavoriteViewController.swift
//  EventHub
//
//  Created by Hoan Le on 10/6/15.
//  Copyright © 2015 Eagle-team. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UITableViewDataSource, UITableViewDelegate{

    var events: [PFObject]!
    var eventsForShow:[PFObject]!
    
//    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var calendar: FSCalendar!
    
//    @IBOutlet weak var favoriteTableView: UITableView!
     @IBOutlet weak var favoriteTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        self.favoriteTableView.rowHeight = UITableViewAutomaticDimension
        self.favoriteTableView.estimatedRowHeight = 200
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "expandCalendar:")
        calendar.addGestureRecognizer(panGesture)
        
//        calendar.appearance.eventColor = UIColor.greenColor()
        calendar.appearance.selectionColor = UIColor.blueColor()
        calendar.appearance.todayColor = UIColor.orangeColor()
        
        // the first time load viewcontroller so reload favorite events
        events = []
        eventsForShow = []

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func expandCalendar(sender:UIPanGestureRecognizer) {
        print("pan")
        var velocity = sender.velocityInView(calendar)
        if velocity.y < 0 {
            calendar.scope = .Week
        }
        else {
            calendar.scope = .Month
        }
    }
    
    func calendar(calendar: FSCalendar!, hasEventForDate date: NSDate!) -> Bool {
//        let calendar = NSCalendar.currentCalendar()
//        let components = calendar.components([.Day, .Month, .Year], fromDate: date)
//        print(components)
//        
//        let day = components.day < 10 ? "0\(components.day)" : "\(components.day)"
//        let month = components.month < 10 ? "0\(components.month)" : "\(components.month)"
//        let dateSelected = "\(components.year)-\(month)-\(day)"
        let dateSelected = getDateString(date)
        
        for event in events {
            let dateString = event.objectForKey("eventStartTime") as! String
            var dateArr = dateString.characters.split{$0 == " "}.map(String.init)
            var date:String = dateArr[0]
            if date == dateSelected {
//                eventsForShow.append(event)
                //                self.favoriteTableView.reloadData()
                return true
            }
        }
        return false
    }
    
    
    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
        print(date)
        //        let calendar = NSCalendar.currentCalendar()
        //        let components = calendar.components([.Day, .Month, .Year], fromDate: date)
        //        print(components)
        //
        //        let day = components.day < 10 ? "0\(components.day)" : "\(components.day)"
        //        let month = components.month < 10 ? "0\(components.month)" : "\(components.month)"
        //        let dateSelected = "\(components.year)-\(month)-\(day)"
        //        print(dateSelected)
        let selectedDate = getDateString(date)
        eventsForShow = []
        getDateHasEvents(selectedDate)
    }
    
    func getDateString(date:NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: date)
        print(components)
        
        let day = components.day < 10 ? "0\(components.day)" : "\(components.day)"
        let month = components.month < 10 ? "0\(components.month)" : "\(components.month)"
        let dateSelected = "\(components.year)-\(month)-\(day)"
        return dateSelected
    }
    
    func getDateHasEvents(selectedDate: String) {
        for event in events {
            let dateString = event.objectForKey("eventStartTime") as! String
            var dateArr = dateString.characters.split{$0 == " "}.map(String.init)
            var date:String = dateArr[0]
            if date == selectedDate {
                eventsForShow.append(event)
                //                self.favoriteTableView.reloadData()
            }
            
//            obj["eventId"] = self.event!.ID!
//            obj["eventTitle"] = self.event?.title
//            obj["eventAddress"] = self.event?.address
//            obj["eventStartTime"] = self.event?.startTime
        }
        self.favoriteTableView.reloadData()
    }
    
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    func calendar(calendar: FSCalendar!, imageForDate date: NSDate!) -> UIImage! {
        if hasEvents(date) {
            return UIImage(named: "event-calendar-icon")
        }
        return nil
    }
    
    func hasEvents(date:NSDate) -> Bool {
        let dateSelected = getDateString(date)
        
        for event in events {
            let dateString = event.objectForKey("eventStartTime") as! String
            var dateArr = dateString.characters.split{$0 == " "}.map(String.init)
            var date:String = dateArr[0]
            if date == dateSelected {
                //                eventsForShow.append(event)
                //                self.favoriteTableView.reloadData()
                return true
            }
        }
        return false

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("Appear")
        // get favorite events from local data store
        var query = PFQuery(className:"FavoriteEvent")
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                //                for events in objects! {
                //                    print(events)
                //                }
                // update ui
                //                self.updateView(objects!)
                self.events = objects
                print("So event lay duoc = \(self.events.count)")
                self.favoriteTableView.reloadData()
            }
            else {
                print("Query fails")
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.eventsForShow.count > 0 {
            return 1
        }
        else {
            // Display a message when the table is empty
            let messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.width, 60))
            
            messageLabel.text = "No have event for this day."
            messageLabel.textColor = UIColor.blackColor()
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.font = UIFont(name: "Palatino-Italic", size: 20)
            
            messageLabel.sizeToFit()
            
            self.favoriteTableView.backgroundView = messageLabel;
            self.favoriteTableView.separatorStyle = UITableViewCellSeparatorStyle.None
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.eventsForShow.count > 0 {
            print("\(self.eventsForShow.count)")
            return self.eventsForShow.count
            
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("FavoritesCell", forIndexPath: indexPath) as? FavoritesCell
        cell!.titleLable.text = eventsForShow[ indexPath.row].objectForKey("eventTitle") as? String
        cell!.addressLabel.text = eventsForShow[indexPath.row].objectForKey("eventAddress") as? String
        cell!.posterImage.setImageWithURL(NSURL(string: (eventsForShow[indexPath.row].objectForKey("eventUrl") as? String)!))
        cell!.hourLabel.text = getHour((eventsForShow[indexPath.row].objectForKey("eventStartTime") as? String)!)
        return cell!    }
    
    func getHour(date:String) -> String {
        var dateArr = date.characters.split{$0 == " "}.map(String.init)
        var hour:String = dateArr[1]
        return hour
    }
    
    func updateView(events:[PFObject]) {
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    

}
