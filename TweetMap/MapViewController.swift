//
//  MapViewController.swift
//  TweetMap
//
//  Created by GLR on 12/16/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation
import TwitterKit

@objc
protocol CenterViewControllerDelegate
{
   func updateTitleColor(color: UIColor)
   func updateStatusBarStyle(style: UIStatusBarStyle)
   
   optional func toggleLeftPanel()
   optional func collapseSidePanel()
}

private extension UIStoryboard
{
   class func locationAlertViewController() -> LocationAlertViewController
   {
      let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
      let controller = mainStoryboard.instantiateViewControllerWithIdentifier("LocationAlertViewControllerID") as! LocationAlertViewController
      controller.modalPresentationStyle = .OverCurrentContext
      return controller
   }
   
   class func topTweetsViewController() -> TopTweetsViewController
   {
      let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
      let controller = mainStoryboard.instantiateViewControllerWithIdentifier("TopTweetsViewControllerID") as! TopTweetsViewController
      return controller
   }
}

class MapViewController: UIViewController, MGLMapViewDelegate, UIPopoverPresentationControllerDelegate
{
   @IBOutlet weak var map: MGLMapView! {
      didSet {
         map.logoView.hidden = true
      }
   }
   
   @IBOutlet private weak var _metricOrNotSetmentedControl: UISegmentedControl!
   
   @IBOutlet weak var layerView: UIView!
   @IBOutlet weak var radiusMenuButton: UIButton!
   @IBOutlet private weak var _updateTrendsButton: UIButton!
   
   @IBOutlet weak var viewContainerForTrends: UIView!
   
   @IBOutlet var trendLabelViews: [TrendingLabelView]!
   
   var delegate: CenterViewControllerDelegate?
   
   var trends: [Trend] = []
   var tweets: [Tweet] = []
   
   private let _topTweetsViewController = UIStoryboard.topTweetsViewController()
   private let radiusMenuPopover = Popover(options: PopoverOption.defaultOptions, showHandler: nil, dismissHandler: nil)
   
   private var zoomLevelTableViewDataSource: ZoomLevelTableViewDataSource?
   private var zoomLevelTableViewDelegate: ZoomLevelTableViewDelegate?
   
   private var _selectedIndex = 0
   private var _currentZoomLevel = 10.0
   
   private let _trendProvider = TwitterTrendMaker()
   
   private let _locationAlertViewController = UIStoryboard.locationAlertViewController()
   private let _fadeTransitionManager = FadeTransitionManager()
   private let _locationManager = CLLocationManager()
   
   private var _alreadyShowedUserLocationAlert = false
   private var _alreadyShowedUserAppSettingsAlert = false
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
      navigationItem.title = "Trends"
      
      // these sublayer lines pull from the MaskLayer class, basically where the 2 functions got moved
      let maskLayer = MaskLayer()
      let caLayer = maskLayer.drawShadedRegion()
      let gradientLayer = maskLayer.drawGradienForTopAndBottom()
      
      layerView.layer.addSublayer(caLayer)
      view.layer.insertSublayer(gradientLayer, atIndex: 1)
      
      radiusMenuButton.layer.cornerRadius = radiusMenuButton.frame.height * 0.5
      _updateTrendsButton.layer.cornerRadius = _updateTrendsButton.frame.height * 0.5
      
      for view in trendLabelViews {
         view.hidden = true
         view.delegate = self
      }
      
      _locationManager.delegate = self
      switch CLLocationManager.authorizationStatus() {
      case .NotDetermined, .Denied, .Restricted: map.centerOnDetroit()
      default: break
      }
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      
      self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
      self.navigationController?.navigationBar.shadowImage = UIImage()
      self.navigationController?.navigationBar.translucent = true
      
      delegate?.updateTitleColor(UIColor.whiteColor())
      delegate?.updateStatusBarStyle(.LightContent)
   }
   
   override func viewDidAppear(animated: Bool)
   {
      super.viewDidAppear(animated)
      
      switch CLLocationManager.authorizationStatus() {
      case .AuthorizedWhenInUse:
         _locationManager.startUpdatingLocation()
      case .NotDetermined:
         if !_alreadyShowedUserLocationAlert {
            _alreadyShowedUserLocationAlert = true
            _showLocationAlertViewController()
         }
         break
      case .Restricted, .Denied:
         if !_alreadyShowedUserAppSettingsAlert {
            _alreadyShowedUserAppSettingsAlert = true
            _showAlertForOpeningAppSettings()
         }
      default:
         break
      }
   }
   
   // MARK: - Private
   private func _showAlertForOpeningAppSettings()
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
      presentViewController(alertController, animated: true, completion: nil)
   }
   
   private func _showLocationAlertViewController()
   {
      _locationAlertViewController.delegate = self
      _locationAlertViewController.transitioningDelegate = _fadeTransitionManager
      _fadeTransitionManager.presenting = true
      _delay(1.5) { () -> () in
         self.presentViewController(self._locationAlertViewController, animated: true, completion: nil)
      }
   }
   
   private func _delay(delay:Double, closure:()->()) {
      dispatch_after(
         dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
         ),
         dispatch_get_main_queue(), closure)
   }
   
   // MARK: - Public
   func updateTrendsWithLocation(location: CLLocation)
   {
      let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
         longitude: location.coordinate.longitude)
      
      _trendProvider.makeTrendFromTwitterCall(coordinate, radius: 20) { (tweets, trends) -> Void in
         self.reloadTrends()
      }
      map.setCenterCoordinate(coordinate, zoomLevel: _currentZoomLevel, animated: false)
   }
   
   func reloadTrends()
   {
      if _trendProvider.trends != nil   {
         self.trends = _trendProvider.trends!
         dispatch_async(dispatch_get_main_queue()) {
            
            for i in 0..<self.trendLabelViews.count  {
               self.trendLabelViews[i].updateWithTrend(self.trends[i])
            }
         }
      }
   }
   
   //MARK: - IBActions
   @IBAction func menu(sender: AnyObject)
   {
      delegate?.toggleLeftPanel?()
   }
   
   @IBAction func radiusMenuButtonPressed(sender: AnyObject)
   {
      let zoomLevelTableView = createZoomLevelTableView()
      setupDataSourceAndDelegateWithTableView(zoomLevelTableView)
      radiusMenuPopover.show(zoomLevelTableView, fromView: radiusMenuButton)
   }
   
   //MARK: - Prepare for Segue
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
   {
      if (segue.identifier == "trendToDetail") {
         guard let destVC = segue.destinationViewController as? TopTweetsViewController else {
            print("there was an error grabbing TopTweetsVC")
            return
         }
         
         let selectedTrend = self.trends[_selectedIndex]
         destVC.title = selectedTrend.name
         destVC.configureWithTweets(selectedTrend.tweets)
         
         delegate?.updateStatusBarStyle(.Default)
         delegate?.updateTitleColor(UIColor.blackColor())
      }
   }
}

extension MapViewController: TrendingLabelViewDelegate
{
   func trendingLabelViewTrendTapped(trend: Trend)
   {
      _selectedIndex = 0
      
      for index in 0..<trends.count {
         if trends[index] == trend {
            _selectedIndex = index
            break
         }
      }
      
      performSegueWithIdentifier("trendToDetail", sender: nil)
   }
}

extension MapViewController: LocationAlertViewControllerDelegate
{
   func locationAlertViewControllerAllowButtonPressed(controller: LocationAlertViewController)
   {
      _fadeTransitionManager.presenting = false
      _locationAlertViewController.dismissViewControllerAnimated(true) {
         
         self._locationManager.requestWhenInUseAuthorization()
      }
   }
   
   func locationAlertViewControllerNoThanksButtonPressed(controller: LocationAlertViewController)
   {
      _fadeTransitionManager.presenting = false
      _locationAlertViewController.dismissViewControllerAnimated(true) {

         self.updateTrendsWithLocation(CLLocation.detroit)
      }
   }
}

extension MapViewController: SidePanelViewControllerDelegate
{
   func menuSelected(selected: AnyObject) {
      
      if selected is String  {
         
         switch selected as! String {
         case "Contact Us":
            //MARK: Bug, creates visual glitch when opening Safari.
            UIApplication.sharedApplication().openURL(NSURL(string:"http://incipia.co/contact/")!)
            print("contact us")
            break
         case "Rate Us":
            
            //some url, we don't have one yet since it's not submitted
            //                UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/app/idYOUR_APP_ID")!);
            print("rate us. Here's where we take users to the app store to rate the app")
            break
         default:
            break
         }
      }
      delegate?.collapseSidePanel?()
   }
}

extension MapViewController: CLLocationManagerDelegate
{
   func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
   {
      if status == .AuthorizedWhenInUse {
         manager.startUpdatingLocation()
      }
      if status == .Denied || status == .Restricted {
         updateTrendsWithLocation(CLLocation.detroit)
      }
   }
   
   func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
   {
      map.showsUserLocation = true
      manager.stopUpdatingLocation()
      updateTrendsWithLocation(locations[0])
   }
}

// Zoom level stuff...
extension MapViewController
{
   private func createZoomLevelTableView() -> UITableView
   {
      let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 135))
      tableView.scrollEnabled = false
      return tableView
   }
   
   private func setupDataSourceAndDelegateWithTableView(tableView: UITableView)
   {
      zoomLevelTableViewDataSource = ZoomLevelTableViewDataSource(tableView: tableView)
      zoomLevelTableViewDelegate = ZoomLevelTableViewDelegate(tableView: tableView)
      
      zoomLevelTableViewDelegate?.rowSelectionHandler =  { (indexPath: NSIndexPath) -> Void in
         self.updateZoomLevelWithIndexPath(indexPath)
         self.radiusMenuPopover.dismiss()
         
         let updatedButtonTitle = self.zoomLevelTableViewDataSource?.updateButtonTitleWithSelectedIndex(indexPath)
         
         dispatch_async(dispatch_get_main_queue()) {
            self.radiusMenuButton.setTitle(updatedButtonTitle, forState: .Normal)
         }
      }
   }
   
   private func updateZoomLevelWithIndexPath(indexPath: NSIndexPath)
   {
      var mapZoomLevel: Double
      var radius: Int
      
      switch indexPath.row {
      case 0:
         mapZoomLevel = 11.0
         radius = 10
      case 1:
         mapZoomLevel = 10.0
         radius = 20
      case 2:
         mapZoomLevel = 9.0
         radius = 50
      default:
         mapZoomLevel = 10.0
         radius = 20
      }
      
      _currentZoomLevel = mapZoomLevel
      //Updating the menu makes a new call with the new search radius. UI has updated well thus far.
      if let location = CLLocationManager().location
      {  
         let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude)
         
         map.setZoomLevel(mapZoomLevel, animated: true)
         
         _trendProvider.makeTrendFromTwitterCall(coordinate, radius: radius, completion: { (tweets, trends) -> Void in
            self.reloadTrends()
         })
      }
   }
}
