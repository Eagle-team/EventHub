//
//  EventDetailsViewController.swift
//  EventHub
//
//  Created by Anh Nguyen on 9/26/15.
//  Copyright © 2015 Eagle-team. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController, UIPageViewControllerDataSource {

    //@IBOutlet weak var imageSlider: TNImageSliderCollectionViewCell!
    var event : Event!
    var eventDetail: EventDetail!
  
    
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    
    var pageViewController: UIPageViewController!
    var  pageImages: [NSURL]!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        //
        cityLabel.text = event.cityName
        addressLabel.text = event.address
        startTimeLabel.text = event.startTime
        
        EventDetail.fetchEventDetail(event.ID!) { (detail, error) -> Void in
            
            if (error == nil)
            {
                self.eventDetail = detail
                if self.eventDetail.detailImageURLs != nil
                {
                    self.pageImages = self.eventDetail.detailImageURLs
                }
                else
                {
                    self.pageImages = [NSURL]()
                }
            }else
            {
            
                self.pageImages = [NSURL]()
            }
                self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
                self.pageViewController.dataSource = self
            
                let startVC = self.viewControllerAtIndex(0) as ImageItemViewController
                let viewControllers = NSArray(object: startVC)
            
                self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
            
                self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.size.height - 400)
            
                self.addChildViewController(self.pageViewController)
                self.view.addSubview(self.pageViewController.view)
                self.pageViewController.didMoveToParentViewController(self)
            

        }
        
        
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        /*
        println("[ViewController] Prepare for segue")
        
        if( segue.identifier == "seg_imageSlider" ){
            
            imageSlider = segue.destinationViewController as! TNImageSliderViewController
            
        }
        
    */
    }
    
    func viewControllerAtIndex(index: Int) -> ImageItemViewController
    {
        if (self.pageImages == nil || (self.pageImages.count == 0) || (index >= self.pageImages.count)) {
            return ImageItemViewController()
        }
        
        let vc: ImageItemViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageItemViewController") as! ImageItemViewController
        
        vc.imageFile = self.pageImages[index]
        vc.pageIndex = index
        
        return vc
        
        
    }
    
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        
        let vc = viewController as! ImageItemViewController
        var index : Int!
        if (vc.pageIndex != nil)
        {
            index = vc.pageIndex as Int
        }
        
        if (index == 0 || index == NSNotFound)
        {
            return nil
            
        }
        
        index!--
        
        return self.viewControllerAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ImageItemViewController
        var index = vc.pageIndex as Int
        
        if (index == NSNotFound)
        {
            return nil
        }
        
        index++
        
        if (index == self.pageImages.count)
        {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return self.pageImages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
}
