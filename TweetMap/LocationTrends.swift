//
//  LocationTrends.swift
//  TweetMap
//
//  Created by GLR on 12/22/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import Foundation

class LocationTrends    {
    
    var asOf = NSDate()
    var createdAt = NSDate()
    
    var locationName = String()
    var locationID = Int()
    
    var trends = [Trend]()
    
    init(locationName: String, trends: [Trend])  {
        self.locationName = locationName
    }
}

var detroit = LocationTrends(locationName: "Detroit", trends: [NBA, hiring, ios, elect])
