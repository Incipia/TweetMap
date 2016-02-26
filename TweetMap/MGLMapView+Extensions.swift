//
//  MGLMapView+Extensions.swift
//  TweetMap
//
//  Created by Gregory Klein on 2/26/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Mapbox

extension CLLocationCoordinate2D
{
   static var detroitCenter: CLLocationCoordinate2D {
      let detroitLat = 42.3314
      let detroitLong = -83.0458
      
      let detroitCenter = CLLocationCoordinate2D(latitude: detroitLat, longitude: detroitLong)
      return detroitCenter
   }
}

extension CLLocation
{
   static var detroit: CLLocation {
      let detroitCenter = CLLocationCoordinate2D.detroitCenter
      return CLLocation(latitude: detroitCenter.latitude, longitude: detroitCenter.longitude)
   }
}

extension MGLMapView
{
   func centerOnDetroit()
   {
      setCenterCoordinate(CLLocationCoordinate2D.detroitCenter, zoomLevel: 11.0, animated: false)
   }
}
