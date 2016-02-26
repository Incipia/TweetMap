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

private extension UIStoryboard
{
   class func locationAlertViewController() -> LocationAlertViewController
   {
      let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
      let controller = mainStoryboard.instantiateViewControllerWithIdentifier("LocationAlertViewControllerID") as! LocationAlertViewController
      controller.modalPresentationStyle = .OverCurrentContext
      return controller
   }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
   var window: UIWindow?
   private var _locationManager = CLLocationManager()
   private let _locationAlertViewController = UIStoryboard.locationAlertViewController()
   private let _containerViewController = ContainerViewController()
   private var _currentLocation: CLLocation?
   private var _mapViewIsLoaded = false
   
   func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
   {
      Fabric.with([Twitter.self, MGLAccountManager.self, Crashlytics.self])
      
      window = UIWindow(frame: UIScreen.mainScreen().bounds)
      
      var controller: UIViewController = _containerViewController
      if CLLocationManager.authorizationStatus() == .NotDetermined {
         controller = _locationAlertViewController
      }
      else if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
         _locationManager.startUpdatingLocation()
         _locationManager.delegate = self
         _mapViewIsLoaded = true
      }
      
      _locationAlertViewController.delegate = self
      window!.rootViewController = controller
      window!.makeKeyAndVisible()
      
      return true
   }
}

extension AppDelegate: LocationAlertViewControllerDelegate
{
   func locationAlertViewControllerAllowButtonPressed(controller: LocationAlertViewController)
   {
      if CLLocationManager.authorizationStatus() == .NotDetermined {
         _locationManager.requestWhenInUseAuthorization()
      }
      _locationManager.delegate = self
   }
   
   func locationAlertViewControllerNoThanksButtonPressed(controller: LocationAlertViewController)
   {
   }
}

extension AppDelegate: CLLocationManagerDelegate
{
   func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
   {
      if _currentLocation == nil && _mapViewIsLoaded
      {
         _currentLocation = locations[0]
         _containerViewController.mapViewController.updateTrendsWithLocation(_currentLocation!)
      }
   }
   
   func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
   {
      if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
         manager.startUpdatingLocation()
         _locationAlertViewController.presentViewController(_containerViewController, animated: true, completion: { () -> Void in
            self._mapViewIsLoaded = true
         })
      }
   }
}

