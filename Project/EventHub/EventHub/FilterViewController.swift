//
//  FilterViewController.swift
//  SwitchNavDynamic
//
//  Created by datdn1 on 9/26/15.
//  Copyright (c) 2015 datdn1. All rights reserved.
//

import UIKit

@objc protocol FilterViewControllerDelegate {
    optional func filterViewController(filterViewController:FilterViewController?, didUpdateFilters filters:[String:AnyObject])
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var filterTableView: UITableView!
    
    weak var delegate:FilterViewControllerDelegate?
    
    var filters = [
        FilterSection(titleHeader: "Time", parameterFilterName: "date", itemsInSection: [
            ItemInSection(title: "All", parameterValue: "All", selected: true),
            ItemInSection(title: "Future", parameterValue: "Future", selected: false),
            ItemInSection(title: "Today", parameterValue: "Today", selected: false),
            ItemInSection(title: "This week", parameterValue: "This week", selected: false),
            ItemInSection(title: "Next week", parameterValue: "Next week", selected: false)],
            filterSectionType: FilterSectionType.SingleChoose,
            expanded: false),
        FilterSection(titleHeader: "Distance", parameterFilterName: "within", itemsInSection: [
            ItemInSection(title: "1", parameterValue: 1, selected: true),
            ItemInSection(title: "10", parameterValue: 10, selected: false),
            ItemInSection(title: "20", parameterValue: 20, selected: false)],
            filterSectionType: .SingleChoose,
            expanded: false),
        FilterSection(titleHeader: "Sort by", parameterFilterName: "sort_order", itemsInSection: [
            ItemInSection(title: "Popularity", parameterValue: "popularity", selected: true),
            ItemInSection(title: "Date", parameterValue: "date", selected: false),
            ItemInSection(title: "Relevance", parameterValue: "relevance", selected: false)],
            filterSectionType: .SingleChoose,
            expanded: false),
        FilterSection(titleHeader: "Categories", parameterFilterName: "category", itemsInSection: [
            ItemInSection(title: "Concerts & Tour Dates", parameterValue: "music", selected: false),
            ItemInSection(title: "Conferences & Tradeshows", parameterValue: "conference", selected: false),
            ItemInSection(title: "Comedy", parameterValue: "comedy", selected: false),
            ItemInSection(title: "Education", parameterValue: "learning_education", selected: false),
            ItemInSection(title: "Kids & Family", parameterValue: "family_fun_kids", selected: false),
            ItemInSection(title: "Festivals", parameterValue: "festivals_parades", selected: false),
            ItemInSection(title: "Film", parameterValue: "movies_film", selected: false),
            ItemInSection(title: "Food & Wine", parameterValue: "food", selected: false),
            ItemInSection(title: "Fundraising & Charity", parameterValue: "fundraisers", selected: false),
            ItemInSection(title: "Art Galleries & Exhibits", parameterValue: "art", selected: false),
            ItemInSection(title: "Health & Wellness", parameterValue: "support", selected: false),
            ItemInSection(title: "Holiday", parameterValue: "holiday", selected: false),
            ItemInSection(title: "Literary & Books", parameterValue: "books", selected: false),
            ItemInSection(title: "Museums & Attractions", parameterValue: "attractions", selected: false),
            ItemInSection(title: "Neighborhood", parameterValue: "community", selected: false),
            ItemInSection(title: "Business & Networking", parameterValue: "business", selected: false),
            ItemInSection(title: "Nightlife & Singles", parameterValue: "singles_social", selected: false),
            ItemInSection(title: "University & Alumni", parameterValue: "schools_alumni", selected: false),
            ItemInSection(title: "Organizations & Meetups", parameterValue: "clubs_associations", selected: false),
            ItemInSection(title: "Outdoors & Recreation", parameterValue: "outdoors_recreation", selected: false),
            ItemInSection(title: "Performing Arts", parameterValue: "performing_arts", selected: false),
            ItemInSection(title: "Pets", parameterValue: "animals", selected: false),
            ItemInSection(title: "Politics & Activism", parameterValue: "politics_activism", selected: false),
            ItemInSection(title: "Sales & Retail", parameterValue: "sales", selected: false),
            ItemInSection(title: "Science", parameterValue: "science", selected: false),
            ItemInSection(title: "Religion & Spirituality", parameterValue: "religion_spirituality", selected: false),
            ItemInSection(title: "Sports", parameterValue: "sports", selected: false),
            ItemInSection(title: "Technology", parameterValue: "technology", selected: false),
            ItemInSection(title: "Other & Miscellaneous", parameterValue: "other", selected: false)],
            filterSectionType: .MultiChoose, expanded: false)
        ]
    
    
    @IBAction func onCancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearch(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let params = createParams()
        self.delegate?.filterViewController!(self, didUpdateFilters: params)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.filterTableView.delegate = self
        self.filterTableView.dataSource = self
        
        self.title = "Filter"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.filters.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filterSection = self.filters[section]
        if filterSection.filterSectionType == .SingleChoose {
            if filterSection.expanded == true {
                return filterSection.itemsInSection!.count
            }
            else {
                return 1
            }
        }
        else {
            if filterSection.expanded == true {
                return filterSection.itemsInSection!.count
            }
            else {
                return 4
            }
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
//        let filterCell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath) as! UITableViewCell
        let cellIdentifier = "FilterCell"
        let customFilterCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        
//        filterCell.textLabel?.textAlignment = NSTextAlignment.Left
//        let customFilterCell = customCell(filterCell)
        let filterSection = filters[indexPath.section]
        
        switch filterSection.filterSectionType! {
        case .SingleChoose:
            if filterSection.expanded! {
                // disable selected row
                customFilterCell.selectionStyle = UITableViewCellSelectionStyle.None
                
                let rowItem = filterSection.itemsInSection![indexPath.row]
                customFilterCell.textLabel?.text = rowItem.title
                //var filterSwitch = createCustomSwitch(false)
                if rowItem.selected! {
                    //filterSwitch = createCustomSwitch(true)
//                    customFilterCell.accessoryView = filterSwitch
                    customFilterCell.accessoryView = UIImageView(image: UIImage(named: "checked-icon"))
                }
                else {
                    customFilterCell.accessoryView = UIImageView(image: UIImage(named: "unchecked-icon"))
                }
                //customFilterCell.accessoryView = filterSwitch
                
//                else {
//                    let filterSwitch = createCustomSwitch(false)
//                    customFilterCell.accessoryView = filterSwitch
//                }
            }
            else {
                customFilterCell.textLabel?.text = filterSection.itemsInSection![filterSection.selectedItemIndex].title
                customFilterCell.accessoryView = UIImageView(image:UIImage(named: "arrow-down-32"))
            }
        case .MultiChoose:
            if filterSection.expanded! || indexPath.row < 3 {
                customFilterCell.selectionStyle = .None
                let rowItem = filterSection.itemsInSection![indexPath.row]
                customFilterCell.textLabel?.text = rowItem.title
                var filterSwitch = createCustomSwitch(false)
                if rowItem.selected! {
                    filterSwitch = createCustomSwitch(true)
                }
                filterSwitch.addTarget(self, action: "onFilterSwitch:", forControlEvents: UIControlEvents.ValueChanged)
                customFilterCell.accessoryView = filterSwitch
            }
            else {
                customFilterCell.textLabel?.text = "See All"
                customFilterCell.textLabel?.textAlignment = NSTextAlignment.Center
                customFilterCell.textLabel?.textColor = UIColor.redColor()
                customFilterCell.tag = 100
            }
            
        default:
            break
            
        }
        
        return customFilterCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let filterSection = filters[indexPath.section]
        switch filterSection.filterSectionType! {
        case .SingleChoose:
            if filterSection.expanded! {
                let preSelectedIndex = filterSection.selectedItemIndex
                if preSelectedIndex != indexPath.row {
                    filterSection.selectedItemIndex = indexPath.row
                }
            }
            let expanded = filterSection.expanded!
            filterSection.expanded = !expanded
            if expanded {
                self.filterTableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            }
            else {
                self.filterTableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            }
        case .MultiChoose:
            let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
            if !(filterSection.expanded!) {
                if selectedCell?.tag == 100 {
                    filterSection.expanded = true
                    self.filterTableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
                }
//                else {
//                    let selectedItem = filterSection.itemsInSection![indexPath.row]
//                    filters[indexPath.section].itemsInSection![indexPath.row].selected = !(selectedItem.selected!)
//                    self.filterTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//                }
            }
//            else {
//                let selectedItem = filterSection.itemsInSection![indexPath.row]
//                filters[indexPath.section].itemsInSection![indexPath.row].selected = !(selectedItem.selected!)
//                self.filterTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//            }
        default:
            break
        }
    }
    
    func customCell(var cell:UITableViewCell) -> UITableViewCell {
        cell.configureFlatCellWithColor(UIColor.greenSeaColor(), selectedColor: UIColor.cloudsColor())
        cell.cornerRadius = 10.0
        cell.separatorHeight = 1.0
        return cell
    }
    
    
    
    func createCustomSwitch(onSwitch:Bool) -> FUISwitch {
        // create switch
        let filterChooseSwitch = FUISwitch(frame: CGRectMake(0, 0, 70, 25))
        filterChooseSwitch.onColor = UIColor.turquoiseColor()
        filterChooseSwitch.offColor = UIColor.cloudsColor()
        filterChooseSwitch.onBackgroundColor = UIColor.midnightBlueColor()
        filterChooseSwitch.offBackgroundColor = UIColor.silverColor()
        filterChooseSwitch.offLabel!.font = UIFont.boldFlatFontOfSize(14)
        filterChooseSwitch.onLabel!.font = UIFont.boldFlatFontOfSize(14)
        filterChooseSwitch.on = onSwitch
        return filterChooseSwitch
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.filters[section].titleHeader
    }
    
    
    func onFilterSwitch(sender:FUISwitch) {
        let pointInTable: CGPoint =  sender.convertPoint(sender.bounds.origin, toView: self.filterTableView)
        let indexPath = self.filterTableView.indexPathForRowAtPoint(pointInTable)
        
        let filterSection = filters[indexPath!.section]
        let selectedItem = filterSection.itemsInSection![indexPath!.row]
        filters[indexPath!.section].itemsInSection![indexPath!.row].selected = !(selectedItem.selected!)
        self.filterTableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
    }
    
    func createParams() -> [String:AnyObject] {
        var params = [String:AnyObject]()
        for filter in filters {
            if filter.filterSectionType! == .SingleChoose {
                params[filter.parameterFilterName!] = filter.itemsInSection![filter.selectedItemIndex].parameterValue
            }
            else {
                var param = [String]()
                for item in filter.selectedItems {
                    param.append(item.parameterValue as! String)
                }
                params[filter.parameterFilterName!] = param
            }
        }
        print(params)
        return params
    }
    
    
    
}















