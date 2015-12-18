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
    
    
    var mapView: MGLMapView!
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var zoomControl: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.bringSubviewToFront(zoomControl)
        
        getUserLocation()
        
        // Default coordinates for Detroit
        let coordinates = (42.3314, -83.0458)
        
        // set the map's center coordinate
        map.setCenterCoordinate(CLLocationCoordinate2D(latitude: coordinates.0,
            longitude: coordinates.1),
            zoomLevel: 8, animated: false)
        
        map.delegate = self
        map.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
