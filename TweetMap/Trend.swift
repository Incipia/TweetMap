//
//  Trend.swift
//  TweetMap
//
//  Created by GLR on 12/22/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import Foundation

class Trend {
    
    var tweetVolume = Int()
    var name = String()
    
    init(name: String, tweetVolume: Int)    {
        self.name = name
        self.tweetVolume = tweetVolume
    }
}

var NBA = Trend(name: "NBA", tweetVolume: 23600)
var hiring = Trend(name: "hiring", tweetVolume: 5800)
var elect = Trend(name: "elect", tweetVolume: 13200)
var ios = Trend(name: "iosdesign", tweetVolume: 8600)
var newYear = Trend(name: "happyNewYear", tweetVolume: 13400)

