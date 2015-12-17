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
    
    var mapView: MGLMapView!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserLocation()
        
        // initialize the map view
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        // Default coordinates for Detroit
        let coordinates = (42.3314, -83.0458)
        
        // set the map's center coordinate
        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: coordinates.0,
            longitude: coordinates.1),
            zoomLevel: 8, animated: false)
        view.addSubview(mapView)
        
        mapView.delegate = self
        mapView.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: location.latitude,
            longitude: location.longitude),
            zoomLevel: 8, animated: false)
        view.addSubview(mapView)
    }

}
