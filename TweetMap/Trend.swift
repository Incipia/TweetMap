//
//  Trend.swift
//  TweetMap
//
//  Created by GLR on 12/22/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import Foundation
import UIKit

public class Trend {
    
    var tweetVolume = Int()
    var name = String()
    var tweets = [Tweet]()
    
    init(name: String, tweetVolume: Int)    {
        self.name = name
        self.tweetVolume = tweetVolume
    }
}

func ==(lhs: Trend, rhs: Trend) -> Bool
{
   // HACK FOR NOW! :D
   return lhs.tweetVolume == rhs.tweetVolume && lhs.name == rhs.name
}






