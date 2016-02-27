//
//  AppDelegate.swift
//  TweetMap
//
//  Created by GLR on 12/16/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit
import Fabric
import Mapbox
import Crashlytics
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
   var window: UIWindow?
   private let _containerViewController = ContainerViewController()
   
   func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
   {
      Fabric.with([Twitter.self, MGLAccountManager.self, Crashlytics.self])
      
      window = UIWindow(frame: UIScreen.mainScreen().bounds)
      window!.rootViewController = _containerViewController
      window!.makeKeyAndVisible()
      
      window?.backgroundColor = UIColor.blueColor()
      
      return true
   }
}

