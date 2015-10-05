//
//  SettingsViewController.swift
//  EventHub
//
//  Created by Hoan Le on 10/4/15.
//  Copyright © 2015 Eagle-team. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, SearchLocationViewControllerDelegate{


 
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var cityName: UILabel!

  
    @IBAction func onTouchChangeLocation(sender: AnyObject) {
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
               let settingVCNavigator = mainStoryBoard.instantiateViewControllerWithIdentifier("SearchNavigationVC") as? UINavigationController
        let searchCityVC = settingVCNavigator?.viewControllers[0] as! SearchLocationViewController
       // settingViewController.delegate = self
        
        self.navigationController?.pushViewController(searchCityVC, animated: true)
        /*

        let searchLocationVc = mainStoryBoard.instantiateViewControllerWithIdentifier("SearchLocationViewController")  as! SearchLocationViewController
        searchLocationVc.delegate = self
        self.presentViewController(searchLocationVc, animated: true, completion: nil)
 */

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func filtersViewControllerUpdateDistanceState(searchLocationViewController: SearchLocationViewController, near: String){
        cityName.text = near
    }
    

    
    // MARK: - Table view data source
    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
