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

class MapViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MGLMapView!
    @IBOutlet weak var zoomControl: UIStepper!
    @IBOutlet weak var layerView: UIView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserLocation()
        
        // Default coordinates for Detroit
        let coordinates = (42.3314, -83.0458)
        
        // set the map's center coordinate
        map.setCenterCoordinate(CLLocationCoordinate2D(latitude: coordinates.0,
            longitude: coordinates.1),
            zoomLevel: 8, animated: false)
        
        map.delegate = self
        map.showsUserLocation = true
        map.logoView.hidden = true

        drawRegion()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func drawRegion() {
        
        var fillLayer = CAShapeLayer()
        fillLayer.fillColor = UIColor.grayColor().CGColor
        
        let size = UIScreen.mainScreen().bounds
        var rad: CGFloat = min(size.height, size.width)
        
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
    
    @IBAction func zoomControlPressed(sender: AnyObject) {
            map.setZoomLevel(Double(self.zoomControl.value + 4), animated: true)
    }
    

}
