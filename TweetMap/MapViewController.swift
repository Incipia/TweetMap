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

protocol CenterViewControllerDelegate
{
   func updateCurrentLocation(location: TweetMapLocation?)
   func updateTitleColor(color: UIColor)
   func updateStatusBarStyle(style: UIStatusBarStyle)
   
   func toggleLeftPanel()
   func collapseSidePanel()
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
   
   @IBOutlet weak var layerView: UIView!
   @IBOutlet weak var radiusMenuButton: UIButton!
   @IBOutlet private weak var _updateTrendsButton: UIButton!
   
   @IBOutlet weak var viewContainerForTrends: UIView!
   
   @IBOutlet var trendLabelViews: [TrendingLabelView]! {
      didSet {
         for view in trendLabelViews {
            view.hidden = true
            view.delegate = self
         }
      }
   }
   
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
   private var _shouldUpdateTrendsWithNextReceivedLocation = false
   
   private(set) var currentBigCityLocation: TweetMapLocation? {
      didSet {
         self.delegate?.updateCurrentLocation(currentBigCityLocation)
      }
   }
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
      navigationItem.title = "Trends"
      
      _setupUI()
      
      _locationManager.delegate = self
      switch CLLocationManager.authorizationStatus()
      {
      case .NotDetermined, .Denied, .Restricted:
         currentBigCityLocation = TweetMapLocation.NewYorkCity
         updateTrendsWithLocation(currentBigCityLocation!.location)
      case .AuthorizedWhenInUse:
         _locationManager.startUpdatingLocation()
         _shouldUpdateTrendsWithNextReceivedLocation = true
      default:
         break
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
      case .NotDetermined:
         if !_alreadyShowedUserLocationAlert {
            _alreadyShowedUserLocationAlert = true
            _showLocationAlertViewControllerWithDelay(1.5)
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
   
   // MARK: - Private
   private func _setupUI()
   {
      // these sublayer lines pull from the MaskLayer class, basically where the 2 functions got moved
      let maskLayer = MaskLayer()
      let caLayer = maskLayer.drawShadedRegion()
      let gradientLayer = maskLayer.drawGradienForTopAndBottom()
      
      layerView.layer.addSublayer(caLayer)
      view.layer.insertSublayer(gradientLayer, atIndex: 1)
      
      radiusMenuButton.layer.cornerRadius = radiusMenuButton.frame.height * 0.5
      _updateTrendsButton.layer.cornerRadius = _updateTrendsButton.frame.height * 0.5
   }
   
   private func _showAlertForOpeningAppSettings()
   {
      let alertController = UIAlertController.locationAlert()
      presentViewController(alertController, animated: true, completion: nil)
   }
   
   private func _showLocationAlertViewControllerWithDelay(delay: NSTimeInterval)
   {
      _locationAlertViewController.delegate = self
      _locationAlertViewController.transitioningDelegate = _fadeTransitionManager
      _fadeTransitionManager.presenting = true
      _delay(delay) { () -> () in
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
      
      let radius = _radiusForZoomLevel(Int(_currentZoomLevel))
      _trendProvider.makeTrendFromTwitterCall(coordinate, radius: radius) { (tweets, trends) -> Void in
         self.reloadTrends()
      }
      
      map.setCenterCoordinate(coordinate, zoomLevel: _currentZoomLevel, animated: true)
   }
   
   func reloadTrends()
   {
      if _trendProvider.trends != nil   {
         self.trends = _trendProvider.trends!
         dispatch_async(dispatch_get_main_queue()) {
            
            for index in 0..<self.trends.count {
               guard index < self.trendLabelViews.count else { break }
               self.trendLabelViews[index].updateWithTrend(self.trends[index])
               self.trendLabelViews[index].hidden = false
            }
            
            if self.trends.count < self.trendLabelViews.count {
               for labelIndex in self.trends.count..<self.trendLabelViews.count {
                  self.trendLabelViews[labelIndex].hidden = true
               }
            }
         }
      }
   }
   
   //MARK: - IBActions
   @IBAction func menu(sender: AnyObject)
   {
      delegate?.toggleLeftPanel()
   }
   
   @IBAction func radiusMenuButtonPressed(sender: AnyObject)
   {
      let zoomLevelTableView = createZoomLevelTableView()
      setupDataSourceAndDelegateWithTableView(zoomLevelTableView)
      radiusMenuPopover.show(zoomLevelTableView, fromView: radiusMenuButton)
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

// MARK: - Location Alert View Controller
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
      _locationAlertViewController.dismissViewControllerAnimated(true, completion: nil)
   }
}

// MARK: - Side Panel View Controller
extension MapViewController: SidePanelViewControllerDelegate
{
   func locationSelected(location: TweetMapLocation)
   {
      currentBigCityLocation = location
      updateTrendsWithLocation(location.location)
      delegate?.collapseSidePanel()
   }
}

// MARK: - CLLocationManager
extension MapViewController: CLLocationManagerDelegate
{
   func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
   {
      if status == .AuthorizedWhenInUse {
         manager.startUpdatingLocation()
         map.showsUserLocation = true
         currentBigCityLocation = nil
         _shouldUpdateTrendsWithNextReceivedLocation = true
      }
   }
   
   func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
   {
      if _shouldUpdateTrendsWithNextReceivedLocation {
         _shouldUpdateTrendsWithNextReceivedLocation = false
         updateTrendsWithLocation(locations[0])
         return
      }
      
      if currentBigCityLocation == nil {
         map.setCenterCoordinate(locations[0].coordinate, zoomLevel: _currentZoomLevel, animated: true)
      }
   }
   
   func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
   {
      print("location error: \(error)")
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
   
   private func _radiusForZoomLevel(level: Int) -> Int
   {
      switch level {
      case 11: return 10
      case 10: return 20
      case 9: return 50
      default: return 20
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
      
      if let location = currentBigCityLocation?.location {
         
         let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude)
         
         map.setCenterCoordinate(coordinate, zoomLevel: mapZoomLevel, animated: true)
         _trendProvider.makeTrendFromTwitterCall(coordinate, radius: radius, completion: { (tweets, trends) -> Void in
            self.reloadTrends()
         })
      }
      else if let location = _locationManager.location
      {
         let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude)
         
         map.setCenterCoordinate(coordinate, zoomLevel: mapZoomLevel, animated: true)
         _trendProvider.makeTrendFromTwitterCall(coordinate, radius: radius, completion: { (tweets, trends) -> Void in
            self.reloadTrends()
         })
      }
   }
   
   @IBAction private func _locationButtonPressed()
   {
      switch CLLocationManager.authorizationStatus() {
      case .NotDetermined:
         _showLocationAlertViewControllerWithDelay(0)
         break
      case .Restricted, .Denied:
         _showAlertForOpeningAppSettings()
      case .AuthorizedWhenInUse:
         if let location = _locationManager.location {
            currentBigCityLocation = nil
            updateTrendsWithLocation(location)
         }
      default:
         break
      }
   }
}
