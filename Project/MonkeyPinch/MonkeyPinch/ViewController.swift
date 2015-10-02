//
//  ViewController.swift
//  MonkeyPinch
//
//  Created by Caroline Begbie on 16/04/2015.
//  Copyright (c) 2015 Caroline Begbie. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIGestureRecognizerDelegate {
  @IBOutlet var monkeyPan: UIPanGestureRecognizer!
  @IBOutlet var bananaPan: UIPanGestureRecognizer!
  
  var chompPlayer:AVAudioPlayer? = nil
  var hehePlayer:AVAudioPlayer? = nil
  
  func loadSound(filename:NSString) -> AVAudioPlayer {
    let url = NSBundle.mainBundle().URLForResource(filename as String, withExtension: "caf")
    var error:NSError? = nil
    let player: AVAudioPlayer!
    do {
      player = try AVAudioPlayer(contentsOfURL: url!)
    } catch let error1 as NSError {
      error = error1
      player = nil
    }
    if error != nil {
      print("Error loading \(url): \(error?.localizedDescription)")
    } else {
      player.prepareToPlay()
    }
    return player
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //1
    let filteredSubviews = self.view.subviews.filter({
      $0.isKindOfClass(UIImageView) })
    // 2
    for view in filteredSubviews  {
      // 3
      let recognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
      // 4
      recognizer.delegate = self
      view.addGestureRecognizer(recognizer)
      
      recognizer.requireGestureRecognizerToFail(monkeyPan)
      recognizer.requireGestureRecognizerToFail(bananaPan)
      
      //TODO: Add a custom gesture recognizer too
      let recognizer2 = TickleGestureRecognizer(target: self, action: Selector("handleTickle:"))
      recognizer2.delegate = self
      view.addGestureRecognizer(recognizer2)
    }
    self.chompPlayer = self.loadSound("chomp")
    self.hehePlayer = self.loadSound("hehehe1")
  }
  
  @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
    //comment for panning
    //uncomment for tickling
    //return;
    
    let translation = recognizer.translationInView(self.view)
    if let view = recognizer.view {
      view.center = CGPoint(x:view.center.x + translation.x,
        y:view.center.y + translation.y)
    }
    recognizer.setTranslation(CGPointZero, inView: self.view)
    
    if recognizer.state == UIGestureRecognizerState.Ended {
      // 1
      let velocity = recognizer.velocityInView(self.view)
      let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
      let slideMultiplier = magnitude / 200
      print("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
      
      // 2
      let slideFactor = 0.1 * slideMultiplier     //Increase for more of a slide
      // 3
      var finalPoint = CGPoint(x:recognizer.view!.center.x + (velocity.x * slideFactor),
        y:recognizer.view!.center.y + (velocity.y * slideFactor))
      // 4
      finalPoint.x = min(max(finalPoint.x, 0), self.view.bounds.size.width)
      finalPoint.y = min(max(finalPoint.y, 0), self.view.bounds.size.height)
      
      // 5
      UIView.animateWithDuration(Double(slideFactor * 2),
        delay: 0,
        // 6
        options: UIViewAnimationOptions.CurveEaseOut,
        animations: {recognizer.view!.center = finalPoint },
        completion: nil)
    }
    
  }
  
  @IBAction func handlePinch(recognizer : UIPinchGestureRecognizer) {
    if let view = recognizer.view {
      view.transform = CGAffineTransformScale(view.transform,
        recognizer.scale, recognizer.scale)
      recognizer.scale = 1
    }
  }
  
  @IBAction func handleRotate(recognizer : UIRotationGestureRecognizer) {
    if let view = recognizer.view {
      view.transform = CGAffineTransformRotate(view.transform, recognizer.rotation)
      recognizer.rotation = 0
    }
  }
 
  func gestureRecognizer(_: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
      return true
  }
  
  func handleTap(recognizer: UITapGestureRecognizer) {
    self.chompPlayer?.play()
  }
  
  func handleTickle(recognizer:TickleGestureRecognizer) {
    self.hehePlayer?.play()
  }
  
}

