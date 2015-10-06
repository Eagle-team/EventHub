//
//  ImageItemViewController.swift
//  EventHub
//
//  Created by Anh Nguyen on 9/27/15.
//  Copyright © 2015 Eagle-team. All rights reserved.
//

import UIKit

class ImageItemViewController: UIViewController {
    
    var pageIndex: Int!
    var imageFile: NSURL!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        if (imageFile != nil)
        {
            self.imageView.setImageWithURL(imageFile)
            self.imageView.layer.cornerRadius = 10
            self.imageView.layer.masksToBounds = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
