//
//  EventMapViewController.swift
//  EventHub
//
//  Created by Hoan Le on 9/27/15.
//  Copyright © 2015 Eagle-team. All rights reserved.
//

import UIKit
import MapKit

class EventMapViewController: UIViewController, MKMapViewDelegate{

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
            calloutView = NSBundle.mainBundle().loadNibNamed("customAnnotation", owner: self, options: nil).first as! UIView
            
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
            
            let title = viewCasted?.calloutView?.viewWithTag(6) as! UILabel
            title.text = annotationCasted?.title
            
            let addess = viewCasted?.calloutView?.viewWithTag(1) as! UILabel
            addess.text = annotationCasted?.event?.address
            
            let time = viewCasted?.calloutView?.viewWithTag(2) as! UILabel
            time.text = annotationCasted?.event?.startTime
            
            let favorite = viewCasted?.calloutView?.viewWithTag(4) as! UIButton
            //favorite.setValue(annotationCasted, forKey: "test")
            favorite.addTarget(self, action: "onTab:", forControlEvents: UIControlEvents.TouchUpInside)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
