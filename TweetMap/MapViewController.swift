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
import BTNavigationDropdownMenu


class MapViewController: DrawerViewController, MGLMapViewDelegate, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var map: MGLMapView!
    @IBOutlet weak var layerView: UIView!
    @IBOutlet weak var radiusMenuButton: UIButton!
    
    @IBOutlet weak var viewContainerForTrends: UIView!
    @IBOutlet var trendLabels: [UILabel]!
    
    var trends = [NBA, hiring, elect, ios, newYear]
    var mapVCTitle = String()
    
    // For popover menu for radiusMenuButton
    private let radiusMenuPopover = Popover(options: PopoverOption.defaultOptions, showHandler: nil, dismissHandler: nil)

    private var radiusMenuOptions = ["10 km", "20 km", "50 km"]
    private var zoomLevelTableViewDataSource: ZoomLevelTableViewDataSource?
    private var zoomLevelTableViewDelegate: ZoomLevelTableViewDelegate?
    
    let locationManager = CLLocationManager()
    var screenwidth : CGFloat!
    var screenheight : CGFloat!
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return .LightContent
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSlideMenuButtonWithColor()
        
        drawRegion()
        
        dropdown()
        
        radiusMenuButton.layer.cornerRadius = 15
        
        getUserLocation()
        
        for each in trendLabels {
            each.layer.cornerRadius = 8
            each.clipsToBounds = true
        }
        
        // Default coordinates for Detroit if location not established
        let coordinates = (42.3314, -83.0458)
        
        // set the map's center coordinate
        map.setCenterCoordinate(CLLocationCoordinate2D(latitude: coordinates.0,
            longitude: coordinates.1),
            zoomLevel: 10.1, animated: false)
        
        map.delegate = self
        map.showsUserLocation = true
        map.logoView.hidden = true

    }
    
    override func viewWillAppear(animated: Bool) {
        
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().translucent = true
//        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        super.viewWillAppear(animated)
        viewContainerForTrends.alpha = 0
        
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().translucent = true
//        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default// I then set the color using:
        
        self.navigationController?.navigationBar.barTintColor   = UIColor.clearColor()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor() // for titles, buttons, etc.
        let navigationTitleFont = UIFont(name: "Helvetica Neue", size: 20)!
        
        self.navigationController?.navigationBar.translucent = true

        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationTitleFont, NSForegroundColorAttributeName: UIColor.whiteColor() ]
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(2.0, delay: 1.0, options: UIViewAnimationOptions.CurveEaseOut, animations:{
            self.viewContainerForTrends.alpha = 0.8}, completion: { complete in
                self.loadTrends()
        })
    }
    
    func loadTrends()   {
        trends.sortInPlace({$0.0.tweetVolume > $0.1.tweetVolume})
        
        for i in 0..<trendLabels.count  {
            trendLabels[i].text = "\(trends[i].name)\n\(trends[i].tweetVolume)"
        }
        
    }
    
    func drawRegion() {
        
        let fillLayer = CAShapeLayer()
        fillLayer.fillColor = UIColor.grayColor().CGColor
        
        let size = UIScreen.mainScreen().bounds
        let rad: CGFloat = min(size.height, size.width)
        
        let path = UIBezierPath(roundedRect: CGRectMake(0, 0, size.width, size.height), cornerRadius: 0.0)
        
        let circlePath = UIBezierPath(roundedRect: CGRectMake(size.width/2.55-(rad/2.0), size.height/2.3-(rad/2.0), rad/0.81, rad/0.81), cornerRadius: rad)

        path.appendPath(circlePath)
        path.usesEvenOddFillRule = true
        
        fillLayer.path = path.CGPath
        fillLayer.fillRule = kCAFillRuleEvenOdd
        fillLayer.fillColor = UIColor.grayColor().CGColor
        fillLayer.opacity = 0.7
        layerView.layer.addSublayer(fillLayer)
    }
    
    
    func getUserLocation(){
//        print("get user location function is being called")
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        
        print("location manager function is being called")
        
        let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
                                            longitude: userLocation.coordinate.longitude)
        map.setCenterCoordinate(location, animated: true)
    }
    
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
            print("Did select item at index: \(indexPath)")
            self.navigationItem.title = items[indexPath]
            
            print(self.navigationItem.title)
            
            if self.navigationItem.title != nil {
                self.mapVCTitle = self.navigationItem.title!
                print(self.mapVCTitle)
            }
        }
    }
    

    @IBAction func radiusMenuButtonPressed(sender: AnyObject) {
        
        let zoomLevelTableView = createZoomLevelTableView()
        setupDataSourceAndDelegateWithTableView(zoomLevelTableView)
        radiusMenuPopover.show(zoomLevelTableView, fromView: radiusMenuButton)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "mapList")  {
            guard let destVC = segue.destinationViewController as? ListTrendsViewController else    {
                print("there was an error grabbing ListTrendsVC")
                return
            }
            destVC.navigationItem.title = self.mapVCTitle
            destVC.trends = trends

            print("mapVC:\(mapVCTitle): \n destVC:\(destVC.navigationItem.title)")
        }
    }
    
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
            self.radiusMenuButton.titleLabel!.text = self.radiusMenuOptions[indexPath.row]
            self.radiusMenuPopover.dismiss()
        }
    }
    
    private func updateZoomLevelWithIndexPath(indexPath: NSIndexPath)
    {
        switch indexPath.row   {
        case 0:
            self.map.setZoomLevel(11.1, animated: true)
        case 1:
            self.map.setZoomLevel(10.1, animated: true)
        case 2:
            self.map.setZoomLevel(9.1, animated: true)
        default:
            self.map.setZoomLevel(10.1, animated: true)
        }
    }
}

