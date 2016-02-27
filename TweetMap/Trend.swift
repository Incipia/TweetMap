//
//  Trend.swift
//  TweetMap
//
//  Created by GLR on 12/22/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import Foundation
import UIKit

private let kTweetVolumeKey = "TrendTweetVolumeKey"
private let kNameKey = "TrendNameKey"
private let kTweetsKey = "TrendTweetsKey"

class Trend: NSObject, NSCoding
{
   var tweetVolume = Int()
   var name = String()
   var tweets = [Tweet]()
   
   init(name: String, tweetVolume: Int)
   {
      self.name = name
      self.tweetVolume = tweetVolume
      
      super.init()
   }
   
   required convenience init?(coder aDecoder: NSCoder)
   {
      let volume = aDecoder.decodeIntegerForKey(kTweetVolumeKey)
      guard let name = aDecoder.decodeObjectForKey(kNameKey) as? String else { return nil }
      guard let tweets = aDecoder.decodeObjectForKey(kTweetsKey) as? [Tweet] else { return nil }
      
      self.init(name: name, tweetVolume: volume)
      self.tweets = tweets
   }
   
   func encodeWithCoder(aCoder: NSCoder)
   {
      aCoder.encodeInteger(tweetVolume, forKey: kTweetVolumeKey)
      aCoder.encodeObject(name, forKey: kNameKey)
      aCoder.encodeObject(tweets, forKey: kTweetsKey)
   }
}

func ==(lhs: Trend, rhs: Trend) -> Bool
{
   // HACK FOR NOW! :D
   return lhs.tweetVolume == rhs.tweetVolume && lhs.name == rhs.name
}
