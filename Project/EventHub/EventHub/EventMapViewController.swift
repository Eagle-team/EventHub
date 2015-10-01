//
//  EventMapViewController.swift
//  EventHub
//
//  Created by Hoan Le on 9/27/15.
//  Copyright © 2015 Eagle-team. All rights reserved.
//

import UIKit
import MapKit

class EventMapViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, FilterViewControllerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    var location: CLLocation?
     var events: [Event]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 1, green: 165/255, blue: 233, alpha: 1)
        
        initMap()
        
        let locationCoordinate = "\(location!.coordinate.latitude),\(location!.coordinate.longitude)"
        print("map \(locationCoordinate)")
        
        Event.searchWithBaseLocation(locationCoordinate, completion: { (events, error) -> Void in
            self.events = events
            for event in events{
                let annotation = EventMKPointAnnotation()
                if (event.latitude != nil || event.longitude != nil){
                    let coordinate = CLLocationCoordinate2DMake((event.latitude as! NSString).doubleValue, (event.longitude as! NSString).doubleValue)
                    annotation.coordinate = coordinate
                    
                    annotation.title = event.title
                    
                    annotation.subtitle = event.address
                    annotation.event = event
                    
                    self.mapView.addAnnotation(annotation)
                }else{
                     print("nil")
                }
            }
        })
    }
    
    func initMap() {
        mapView.delegate = self
        mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(location!.coordinate.latitude,location!.coordinate.longitude), MKCoordinateSpanMake(0.1, 0.1)), animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is  MKPointAnnotation) {
            return nil
        }

        let reuseId = "customAnnotationView"
        var pinView: UIImageView? = nil
        var calloutView: UIView? = nil
        
        var dxAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? CustomAnnotationView
        if (dxAnnotationView == nil){
            pinView = UIImageView(image: imageResize(UIImage(named: "clock")!, sizeChange: CGSizeMake(30, 30)))
            calloutView = NSBundle.mainBundle().loadNibNamed("customAnnotation", owner: self, options: nil).first as! CustomCallOutView
            
            dxAnnotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: reuseId, pinView: pinView, calloutView: calloutView, settings: DXAnnotationSettings.defaultSettings())
        }else{
            dxAnnotationView?.annotation = annotation
            dxAnnotationView?.pinView = pinView
            dxAnnotationView?.calloutView = calloutView
        }
        
        return dxAnnotationView
        
    }
    
    func onTab(sender: UIButton){
        //let anno = sender.valueForKey("test") as? EventMKPointAnnotation
        print("click")
    }
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        for view in views{
            let viewCasted = view as? CustomAnnotationView
            let annotationCasted = view.annotation as? EventMKPointAnnotation
            let callOutView = viewCasted?.calloutView as? CustomCallOutView
            
            callOutView?.eventTitleView.text = annotationCasted?.title
            
            callOutView?.eventAddressLabel.text = annotationCasted?.event?.address
            
            callOutView?.eventTimeLabel.text = annotationCasted?.event?.startTime
            
            callOutView?.event = annotationCasted?.event
        }
    }
    
    func imageResize (image: UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    func filterViewController(filterViewController:FilterViewController?, didUpdateFilters filters:[String:AnyObject]) {
        print(filters)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
