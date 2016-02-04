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

struct Tweet : CustomStringConvertible
{
    let text: String
    let retweets: Int
    let hashtags: [String]
    
    var description: String {
        return "TEXT:\(text)\r RETWEETS:\(retweets)\r HASHTAGS:\(hashtags)\r"
    }
}


