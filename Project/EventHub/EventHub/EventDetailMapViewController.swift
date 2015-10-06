//
//  EventDetailMapViewController.swift
//  EventHub
//
//  Created by Anh Nguyen on 10/1/15.
//  Copyright © 2015 Eagle-team. All rights reserved.
//

import UIKit
import MapKit

class EventDetailMapViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet var mapView: MKMapView!
   
    var location: CLLocation?
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 1, green: 165/255, blue: 233, alpha: 1)
        location = CLLocation(latitude: (event.latitude as! NSString).doubleValue, longitude: (event.longitude as! NSString).doubleValue)
        
        initMap()
        
        let locationCoordinate = "\(location!.coordinate.latitude),\(location!.coordinate.longitude)"
        print("map \(locationCoordinate)")
        
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
    
    func initMap() {
        mapView.delegate = self
        let mkcomake = MKCoordinateRegionMake(CLLocationCoordinate2DMake(location!.coordinate.latitude,location!.coordinate.longitude), MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(mkcomake, animated: false)
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
            pinView = UIImageView(image: imageResize(UIImage(named: "chooselocation")!, sizeChange: CGSizeMake(30, 30)))
            calloutView = NSBundle.mainBundle().loadNibNamed("customAnnotation", owner: self, options: nil).first as! CustomCallOutView
            
            dxAnnotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: reuseId, pinView: pinView, calloutView: calloutView, settings: DXAnnotationSettings.defaultSettings())
            
        
            
        }else{
            dxAnnotationView?.annotation = annotation
            dxAnnotationView?.pinView = pinView
            dxAnnotationView?.calloutView = calloutView
        }
        
        return dxAnnotationView
        
    }
    
    
    func mapView(mapView: MKMapView, didAddAnnotationViews view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
     
            let viewCasted = view as? CustomAnnotationView
            let annotationCasted = view.annotation as? EventMKPointAnnotation
            let callOutView = viewCasted?.calloutView as? CustomCallOutView
            
            callOutView?.eventTitleView.text = annotationCasted?.title
            
            callOutView?.eventAddressLabel.text = annotationCasted?.event?.address
            
            callOutView?.eventTimeLabel.text = annotationCasted?.event?.startTime
            
 
    }
    
    func imageResize (image: UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }

    
    
}
