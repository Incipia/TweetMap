//
//  LocationAlertViewController.swift
//  TweetMap
//
//  Created by Gregory Klein on 2/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

protocol LocationAlertViewControllerDelegate: class
{
   func locationAlertViewControllerAllowButtonPressed(controller: LocationAlertViewController)
   func locationAlertViewControllerNoThanksButtonPressed(controller: LocationAlertViewController)
}

class LocationAlertViewController: UIViewController
{
   @IBOutlet private weak var _allowButton: UIButton!
   @IBOutlet private weak var _noThanksButton: UIButton!
   
   weak var delegate: LocationAlertViewControllerDelegate?
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      _allowButton.layer.cornerRadius = _allowButton.frame.height * 0.5
      _noThanksButton.layer.cornerRadius = _noThanksButton.frame.height * 0.5
      
      _noThanksButton.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(0.2).CGColor
      _noThanksButton.layer.borderWidth = 1.0
   }
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle {
      return .Default
   }
   
   @IBAction private func _allowButtonPressed()
   {
      delegate?.locationAlertViewControllerAllowButtonPressed(self)
   }
   
   @IBAction private func _noThanksButtonPressed()
   {
      delegate?.locationAlertViewControllerNoThanksButtonPressed(self)
   }
}
