//
//  EventDetailsViewController.swift
//  EventHub
//
//  Created by Anh Nguyen on 9/26/15.
//  Copyright © 2015 Eagle-team. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {

    //@IBOutlet weak var imageSlider: TNImageSliderCollectionViewCell!
    var event : Event!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        println("[ViewController] View did load")
        
        
        let image1 = UIImage(named: "image-1")
        
        
        Alamofire.request(.GET, "https://robohash.org/123.png").response { (request, response, data, error) in
            image1 = UIImage(data: data, scale:1)
    }
        
        if let image1 = image1{
            
            // 1. Set the image array with UIImage objects
            imageSlider.images = [image1]
            
            // 2. If you want, you can set some options
            var options = TNImageSliderViewOptions()
            options.pageControlHidden = false
            options.scrollDirection = .Horizontal
            options.pageControlCurrentIndicatorTintColor = UIColor.yellowColor()
            
            imageSlider.options = options
            
        }else {
            
            println("[ViewController] Could not find one of the images in the image catalog")
            
        }
        */
        
        //
        cityLabel.text = event.cityName
        addressLabel.text = event.address
        startTimeLabel.text = event.startTime
        
        
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
    

}
