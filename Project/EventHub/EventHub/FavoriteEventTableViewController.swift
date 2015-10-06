//
//  FavoriteEventTableViewController.swift
//  EventHub
//
//  Created by Hoan Le on 10/5/15.
//  Copyright © 2015 Eagle-team. All rights reserved.
//

import UIKit

class FavoriteEventTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView?
    var favorites: [PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let query = PFQuery(className:"FavoriteEvent")
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if (objects == nil || objects?.count == 0){
                
            }else{
                self.favorites = objects
                
                //anhnguyennotify
                for fav in objects!{
                    
                    var title = fav["eventTitle"] as! String
                    var deadlineString = fav["eventStartTime"] as! String
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date = dateFormatter.dateFromString(deadlineString)
                    
                    let todoItem = TodoItem(deadline: date!, title: title, UUID: NSUUID().UUIDString)
                    TodoList.sharedInstance.addItem(todoItem)

                
                }

            }
            
            self.tableView?.reloadData()
        }
        
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.estimatedRowHeight = 120
        
        //notify
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshList", name: "TodoListShouldRefresh", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (favorites == nil || favorites.count == 0){
            return 0
        } else {
            return favorites.count
        }
    }
    
    
    //anhnguyennotify
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //refreshList()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteCell", forIndexPath: indexPath) as! FavoriteCell
        
        cell.titleLabel.text = favorites[indexPath.row]["eventTitle"] as! String
        cell.timeLabel.text = favorites[indexPath.row]["eventStartTime"] as! String
        cell.addressLabel.text = favorites[indexPath.row]["eventAddress"] as! String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.dateFromString(favorites[indexPath.row]["eventStartTime"] as! String)
        cell.dueDate = date
        
       // cell.textLabel?.text = todoItem.title as String!
        
        if (cell.isOverdue) { // the current time is later than the to-do item's deadline
            cell.titleLabel?.textColor = UIColor.redColor()
        } else {
            cell.titleLabel?.textColor = UIColor.blackColor() // we need to reset this because a cell with red subtitle may be returned by dequeueReusableCellWithIdentifier:indexPath:
        }
        

        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
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
