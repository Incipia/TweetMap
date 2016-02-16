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
import BTNavigationDropdownMenu

@objc
protocol CenterViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func collapseSidePanel()
}

class MapViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var map: MGLMapView!
    @IBOutlet weak var layerView: UIView!
    @IBOutlet weak var radiusMenuButton: UIButton!
    
    @IBOutlet weak var viewContainerForTrends: UIView!
    @IBOutlet var trendLabels: [UILabel]!
    
    @IBOutlet weak var metricOrNot: UISegmentedControl!
    
    
    var delegate: CenterViewControllerDelegate?
    
    var trends: [Trend] = []
    var tweets: [Tweet] = []
    var mapVCTitle = String()
    
    private let radiusMenuPopover = Popover(options: PopoverOption.defaultOptions, showHandler: nil, dismissHandler: nil)
    
    private var zoomLevelTableViewDataSource: ZoomLevelTableViewDataSource?
    private var zoomLevelTableViewDelegate: ZoomLevelTableViewDelegate?
    
    private var _locationManager = CLLocationManager()
    private var _shouldUpdateTrends = true
    private var _selectedIndex = 0
    
    private let _trendGetter = TwitterTrendMaker()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        
        
        let dropdownMenu = Dropdown(navController: self.navigationController, navItem: self.navigationItem)
        dropdownMenu.create()
        
        
        // these sublayer lines pull from the MaskLayer class, basically where the 2 functions got moved
        let maskLayer = MaskLayer()
        let caLayer = maskLayer.drawShadedRegion()
        let gradientLayer = maskLayer.drawGradienForTopAndBottom()
        
        layerView.layer.addSublayer(caLayer)
        self.view.layer.insertSublayer(gradientLayer, atIndex: 1)
        
        
        radiusMenuButton.layer.cornerRadius = 15
                        
        if let location = CLLocationManager().location
        {
            _shouldUpdateTrends = false
            let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude)
            
//            _getTweetsWithCoordinate(coordinate, metricSystem: false, radius: 20)
            _trendGetter._getTweetsWithCoordinate(coordinate, metricSystem: false, radius: 20)
            map.setCenterCoordinate(coordinate, zoomLevel: 10.1, animated: true)
        }
        else // location is not ready, so rely on locationManager:didUpdateLocations:
        {
            _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            _locationManager.startUpdatingLocation()
            _locationManager.delegate = self
        }
        
        for each in trendLabels {
            each.layer.cornerRadius = 5
            each.clipsToBounds = true
        }
        
        map.delegate = self
        map.showsUserLocation = true
        map.logoView.hidden = true
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewContainerForTrends.alpha = 0
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
                
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        

    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(1.0, delay: 0.5,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations:{
                self.viewContainerForTrends.alpha = 0.8},
            completion: { complete in
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    
    
    //MARK: LOCATION MANAGER
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if _shouldUpdateTrends
        {
            _shouldUpdateTrends = false
            let userLocation = locations[0] as CLLocation
            let coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
                longitude: userLocation.coordinate.longitude)
            
//            _getTweetsWithCoordinate(coordinate, metricSystem: false, radius: 20)
            _trendGetter._getTweetsWithCoordinate(coordinate, metricSystem: false, radius: 20)
            map.setCenterCoordinate(coordinate, animated: true)
        }
    }
    
    
    //MARK: NETWORK CALL
//    private func _getTweetsWithCoordinate(coordinate: CLLocationCoordinate2D, metricSystem: Bool, radius: Int)
//    {
//        TwitterNetworkManager.getTweetsForCoordinate(coordinate, metricSystem: metricSystem, radius: radius) { incomingTweets -> () in
//            
//            var hashtagFrequencyDictionary: [String: Int] = [:]
//            var tempTrends: [Trend] = []
//            
//            // for each tweet, go through all the hashtags and populate the hashtagFrequencyDictionary with correct info
//            for tweet in incomingTweets
//            {
//                for hashtag in tweet.hashtags
//                {
//                    if let hashtagCount = hashtagFrequencyDictionary[hashtag] {
//                        hashtagFrequencyDictionary[hashtag] = hashtagCount + 1
//                    }
//                    else {
//                        hashtagFrequencyDictionary[hashtag] = 1
//                    }
//                }
//            }
//            
//            // for each hashtag in the frequency dictionary, get the count and create a trend object
//            for hashtag in hashtagFrequencyDictionary.keys
//            {
//                let name = hashtag
//                let count = hashtagFrequencyDictionary[hashtag]!
//                
//                let trend = Trend(name: name, tweetVolume: count)
//                for tweet in incomingTweets {
//                    if tweet.hashtags.contains(hashtag) {
//                        trend.tweets.append(tweet)
//                    }
//                }
//                tempTrends.append(trend)
//            }
//            self.tweets = incomingTweets
//            self.trends = tempTrends
//            self.reloadTrends()
//        }
//    }
    
    
    func reloadTrends()   {
//        if trends.count < 5 {
//            print("not enough trends to display")
//        } else  {
//            trends.sortInPlace({$0.0.tweetVolume > $0.1.tweetVolume})
            self.trends = _trendGetter.trends!
            for i in 0..<trendLabels.count  {
                trendLabels[i].text = "#\(trends[i].name)\n\(trends[i].tweetVolume)"
//            }
        }
    }
    
    //Mark: UIComponents
    @IBAction func menu(sender: AnyObject) {
        delegate?.toggleLeftPanel?()
    }
    

    @IBAction func radiusMenuButtonPressed(sender: AnyObject)   {
        let zoomLevelTableView = createZoomLevelTableView()
        setupDataSourceAndDelegateWithTableView(zoomLevelTableView)
        radiusMenuPopover.show(zoomLevelTableView, fromView: radiusMenuButton)
    }
    
    @IBAction func trendLabelTapped(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            _selectedIndex = (sender.view?.tag)!
            self.performSegueWithIdentifier("trendToDetail", sender: nil)
        }
    }
    
    //MARK: Navigation
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
        }
    }
    
    
    //MARK: Table View References for Zoom Menu
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
            self.radiusMenuButton.titleLabel!.text = updatedButtonTitle
        }
    }
    

    
    private func updateZoomLevelWithIndexPath(indexPath: NSIndexPath)
    {
        var mapZoomLevel: Double
        var radius: Int
        var metricSystem = false
        
        if metricOrNot.selectedSegmentIndex == 0 {
            metricSystem = true
        }   else    {
            metricSystem = false
        }
        
        switch indexPath.row   {
        case 0:
            mapZoomLevel = 11.0;    radius = 10
        case 1:
            mapZoomLevel = 10.0;    radius = 20
        case 2:
            mapZoomLevel = 9.0;     radius = 50
        default:
            mapZoomLevel = 10.0;    radius = 20
        }
        
        //Updating the menu makes a new call with the new search radius. UI has updated well thus far.
        if let location = CLLocationManager().location
        {
            _shouldUpdateTrends = false
            
            let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude)
            
            map.setZoomLevel(mapZoomLevel, animated: true)
                
//            _getTweetsWithCoordinate(coordinate, metricSystem: metricSystem, radius: radius)
        }
    }
}

extension MapViewController: SidePanelViewControllerDelegate {
    func menuSelected(selected: AnyObject) {
        
        if selected is String  {
            
            switch selected as! String {
            case "Contact Us":
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

