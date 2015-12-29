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
    
    @IBOutlet weak var map: MGLMapView!
    @IBOutlet weak var layerView: UIView!
    @IBOutlet weak var radiusMenuButton: UIButton!
    
    // For popover menu for radiusMenuButton
    private var radiusMenuPopover: Popover!
    private var radiusMenuOptions = ["10 km", "20 km", "50 km"]
    
    let locationManager = CLLocationManager()
    var screenwidth : CGFloat!
    var screenheight : CGFloat!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSlideMenuButton()
        
        drawRegion()
        
        dropdown()
        
        radiusMenuButton.layer.cornerRadius = 15
        
        getUserLocation()
        
        
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
        print("get user location function is being called")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
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
        
        self.navigationItem.titleView = menuView
        
        menuView.backgroundColor = UIColor.clearColor()
        menuView.cellBackgroundColor = UIColor.darkGrayColor()
        menuView.maskBackgroundColor = UIColor.clearColor()
        menuView.cellSelectionColor = UIColor.darkGrayColor()
        menuView.cellSeparatorColor = UIColor.whiteColor()
        menuView.cellTextLabelColor = UIColor.whiteColor()
        menuView.maskBackgroundOpacity = 0
        menuView.menuTitleColor = UIColor.whiteColor()
        
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
        }
    }
    
    

    
    @IBAction func radiusMenuButtonPressed(sender: AnyObject) {
        let options = [
            .Type(.Up),
            .CornerRadius(4.0),
            .AnimationIn(0.5),
            .ArrowSize(CGSizeMake(10.0, 10.0))
            ] as [PopoverOption]
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 135))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollEnabled = false
        self.radiusMenuPopover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        self.radiusMenuPopover.show(tableView, fromView: radiusMenuButton)
    }
}


////// TableView Data Source and delegate for searchRadiusMenu choices ///////

extension MapViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            switch indexPath.row   {
            case 0:
                self.map.setZoomLevel(11.1, animated: true)
                print("case 0 just happened, \(indexPath.row)")
            case 1:
                self.map.setZoomLevel(10.1, animated: true)
                print("case 1 just happened, \(indexPath.row)")

            case 2:
                self.map.setZoomLevel(9.1, animated: true)
                print("case 2 just happened, \(indexPath.row)")

            default:
                print("default just happened, no case executed")
//                self.map.setZoomLevel(10.1, animated: true)
            }
        self.radiusMenuButton.titleLabel!.text = radiusMenuOptions[indexPath.row]
        self.radiusMenuPopover.dismiss()
    }
}

extension MapViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        cell.textLabel?.text = self.radiusMenuOptions[indexPath.row]
        return cell
    }
}
