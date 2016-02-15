//
//  Trend.swift
//  TweetMap
//
//  Created by GLR on 12/22/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import Foundation
import UIKit

class Trend {
    
    var tweetVolume = Int()
    var favoriteCount = Int()
    var retweetCount = Int()
    var name = String()
    var tweets = [Tweet]()
    
    init(name: String, tweetVolume: Int)    {
        self.name = name
        self.tweetVolume = tweetVolume
    }
    
    //Sort trends in 3 ways, hashtags, favoriteCount, and retweets
    //In all 3, sort the tweets array, but by different tweet attributes
    //Assign sorted values to tweetVolume
    
    

}







