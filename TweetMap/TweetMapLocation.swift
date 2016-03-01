//
//  TweetMapLocation.swift
//  TweetMap
//
//  Created by Gregory Klein on 2/29/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import CoreLocation

enum TweetMapLocation
{
   case Austin, NewYorkCity, LosAngeles, Chicago, Washington, Detroit, Atlanta, Seattle, Miami, LasVegas, Honolulu, Anchorage, SanFransisco
   
   var fullName: String {
      switch self {
      case Austin: return "Austin, TX"
      case NewYorkCity: return "New York City, NY"
      case LosAngeles: return "Los Angeles, CA"
      case Chicago: return "Chicago, IL"
      case Washington: return "Washington, D.C."
      case Detroit: return "Detroit, MI"
      case Atlanta: return "Atlanta, GA"
      case Seattle: return "Seattle, WA"
      case Miami: return "Miami, FL"
      case LasVegas: return "Las Vegas, NV"
      case Honolulu: return "Honolulu, HI"
      case Anchorage: return "Anchorage, AK"
      case SanFransisco: return "San Fransisco, CA"
      }
   }
   
   var location: CLLocation {
      switch self {
      case Austin: return CLLocation(latitude: 30.2500, longitude: -97.7500)
      case NewYorkCity: return CLLocation(latitude: 40.7127, longitude: -74.0059)
      case LosAngeles: return CLLocation(latitude: 34.0500, longitude: -118.2500)
      case Chicago: return CLLocation(latitude: 41.8369, longitude: -87.6847)
      case Washington: return CLLocation(latitude: 38.9047, longitude: -77.0164)
      case Detroit: return CLLocation(latitude: 42.3314, longitude: -83.0458)
      case Atlanta: return CLLocation(latitude: 33.7550, longitude: -84.3900)
      case Seattle: return CLLocation(latitude: 47.6097, longitude: -122.3331)
      case Miami: return CLLocation(latitude: 25.7753, longitude: -80.2089)
      case LasVegas: return CLLocation(latitude: 36.1215, longitude: -115.1739)
      case Honolulu: return CLLocation(latitude: 21.3000, longitude: -157.8167)
      case Anchorage: return CLLocation(latitude: 61.2167, longitude: -149.9000)
      case SanFransisco: return CLLocation(latitude: 37.7833, longitude: -122.4167)
      }
   }
}