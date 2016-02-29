//
//  UIAlertViewController+Extensions.swift
//  TweetMap
//
//  Created by Gregory Klein on 2/29/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

extension UIAlertController
{
   static func locationAlert() -> UIAlertController
   {
      let alertController = UIAlertController(
         title: "Location Access Disabled",
         message: "In order to see the hottest new trends around you, please open this app's settings and set location access to 'While Using the App'.",
         preferredStyle: .Alert)
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
      alertController.addAction(cancelAction)
      
      let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
         if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
            UIApplication.sharedApplication().openURL(url)
         }
      }
      alertController.addAction(openAction)
      return alertController
   }
}
