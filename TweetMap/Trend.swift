//
//  Trend.swift
//  TweetMap
//
//  Created by GLR on 12/22/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import Foundation
import TwitterKit
import UIKit

private let kTweetVolumeKey = "TrendTweetVolumeKey"
private let kNameKey = "TrendNameKey"
private let kTweetsKey = "TrendTweetsKey"

class PhraseTrend
{
   let phrase: String
   let tweets: [TWTRTweet]
   
   init(phrase: String, tweets: [TWTRTweet])
   {
      self.phrase = phrase
      self.tweets = tweets
   }
}

class Trend: NSObject, NSCoding
{
   var name = String()
   var tweets = [Tweet]()
   var tweetVolume: Int {
      return tweets.count
   }
   
   init(name: String, tweetVolume: Int)
   {
      self.name = name
      
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
      aCoder.encodeObject(name, forKey: kNameKey)
      aCoder.encodeObject(tweets, forKey: kTweetsKey)
   }
}

func ==(lhs: Trend, rhs: Trend) -> Bool
{
   // HACK FOR NOW! :D
   return lhs.name == rhs.name
}
