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
    
    var delegate: CenterViewControllerDelegate?
    
    var trends: [Trend] = []
    var mapVCTitle = String()
    
    private let radiusMenuPopover = Popover(options: PopoverOption.defaultOptions, showHandler: nil, dismissHandler: nil)
    
    private var zoomLevelTableViewDataSource: ZoomLevelTableViewDataSource?
    private var zoomLevelTableViewDelegate: ZoomLevelTableViewDelegate?
    
    let locationManager = CLLocationManager()
    var screenwidth : CGFloat!
    var screenheight : CGFloat!
    
    private var _locationManager = CLLocationManager()
    
    private var _shouldUpdateTrends = true
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        drawRegion()
        dropdown()
        
        radiusMenuButton.layer.cornerRadius = 15
        
        if let location = CLLocationManager().location
        {
            _shouldUpdateTrends = false
            let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude)
            
            _getTweetsWithCoordinate(coordinate, radius: 20)
            map.setCenterCoordinate(coordinate, zoomLevel: 10.1, animated: true)
        }
        else // location is not ready, so rely on locationManager:didUpdateLocations:
        {
            _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            _locationManager.startUpdatingLocation()
            _locationManager.delegate = self
        }
        
        for each in trendLabels {
            each.layer.cornerRadius = 8
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
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(2.0, delay: 1.0, options: UIViewAnimationOptions.CurveEaseOut, animations:{
            self.viewContainerForTrends.alpha = 0.8}, completion: { complete in
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    
    
    //MARK: Shade outer regions
    func drawRegion() {
        
        let fillLayer = CAShapeLayer()
        fillLayer.fillColor = UIColor.grayColor().CGColor
        
        let size = UIScreen.mainScreen().bounds
        let rad: CGFloat = min(size.height, size.width)
        
        let path = UIBezierPath(roundedRect: CGRectMake(0, 0, size.width, size.height), cornerRadius: 0.0)
        
        let circlePath = UIBezierPath(roundedRect: CGRectMake(size.width/2.55-(rad/2.0), size.height/2.5-(rad/2.0), rad/0.81, rad/0.81), cornerRadius: rad)

        path.appendPath(circlePath)
        path.usesEvenOddFillRule = true
        
        fillLayer.path = path.CGPath
        fillLayer.fillRule = kCAFillRuleEvenOdd
        fillLayer.fillColor = UIColor.grayColor().CGColor
        fillLayer.opacity = 0.7
        
        layerView.layer.addSublayer(fillLayer)
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if _shouldUpdateTrends
        {
            _shouldUpdateTrends = false
            let userLocation = locations[0] as CLLocation
            let coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
                longitude: userLocation.coordinate.longitude)
            
            _getTweetsWithCoordinate(coordinate, radius: 15)
            map.setCenterCoordinate(coordinate, animated: true)
        }
    }
    
    private func _getTweetsWithCoordinate(coordinate: CLLocationCoordinate2D, radius: Int)
    {
        TwitterNetworkManager.getTweetsForCoordinate(coordinate, radius: radius) { tweets -> () in
            
            var hashtagFrequencyDictionary: [String: Int] = [:]
            for tweetObj in tweets
            {
                print(tweetObj)
                print("-----------------------------------------------------")
                for hashtag in tweetObj.hashtags
                {
                    if let hashtagCount = hashtagFrequencyDictionary[hashtag] {
                        hashtagFrequencyDictionary[hashtag] = hashtagCount + 1
                    }
                    else {
                        hashtagFrequencyDictionary[hashtag] = 1
                    }
                }
            }
            
            var tempTrends: [Trend] = []
            for hashtag in hashtagFrequencyDictionary.keys
            {
                let name = hashtag
                let count = hashtagFrequencyDictionary[hashtag]!
                
                let trend = Trend(name: name, tweetVolume: count)
                tempTrends.append(trend)
            }
            
            self.trends = tempTrends
            self.reloadTrends()
        }
    }
    
    func reloadTrends()   {
        if trends.count == 0 {
            print("sorted trends was empty")
        } else  {
            trends.sortInPlace({$0.0.tweetVolume > $0.1.tweetVolume})
            for i in 0..<trendLabels.count  {
                trendLabels[i].text = "#\(trends[i].name)\n\(trends[i].tweetVolume)"
            }
        }
    }
    
    
    
    //Mark: UIComponents
    func dropdown() {
        let items = ["Hashtags", "Words", "Users", "All"]

        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: items.first!, items: items)
        
        mapVCTitle = items.first!
        
        self.navigationItem.titleView = menuView
        
        menuView.backgroundColor = UIColor.clearColor()
        menuView.cellBackgroundColor = UIColor.darkGrayColor()
        menuView.maskBackgroundColor = UIColor.clearColor()
        menuView.cellSeparatorColor = UIColor.whiteColor()
        menuView.cellTextLabelFont = UIFont(name: "Helvetica Neue", size: 20)
        
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            self.navigationItem.title = items[indexPath]
            
            if self.navigationItem.title != nil {
                self.mapVCTitle = self.navigationItem.title!
            }
        }
    }
    
    @IBAction func menu(sender: AnyObject) {
        delegate?.toggleLeftPanel?()
    }
    

    @IBAction func radiusMenuButtonPressed(sender: AnyObject) {
        
        let zoomLevelTableView = createZoomLevelTableView()
        setupDataSourceAndDelegateWithTableView(zoomLevelTableView)
        radiusMenuPopover.show(zoomLevelTableView, fromView: radiusMenuButton)
    }
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "mapList")  {
            guard let destVC = segue.destinationViewController as? ListTrendsViewController else    {
                print("there was an error grabbing ListTrendsVC")
                return
            }
            destVC.navigationItem.title = self.mapVCTitle
            destVC.trends = trends
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
            var updatedButtonTitle = self.zoomLevelTableViewDataSource?.updateButtonTitleWithSelectedIndex(indexPath)
            self.radiusMenuButton.titleLabel!.text = updatedButtonTitle
        }
    }
    
    private func updateZoomLevelWithIndexPath(indexPath: NSIndexPath)
    {
        var mapZoomLevel: Double
        
        switch indexPath.row   {
        case 0:
            mapZoomLevel = 11.0
        case 1:
            mapZoomLevel = 10.0
        case 2:
            mapZoomLevel = 9.0
        default:
            mapZoomLevel = 10.0
        }
        map.setZoomLevel(mapZoomLevel, animated: true)
    }
}

extension MapViewController: SidePanelViewControllerDelegate {
    func menuSelected(selected: AnyObject) {
        delegate?.collapseSidePanel?()
    }
}

