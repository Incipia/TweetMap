//
//  Tweet.swift
//  TweetMap
//
//  Created by GLR on 2/5/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import TwitterKit

private let kObjectKey = "TweetObjectKey"
private let kHashtagsKey = "TweetHashtagsKey"

class Tweet: NSObject, NSCoding
{
   private(set) var object: TWTRTweet
   private(set) var hashtags: [String]
   
   init(object: TWTRTweet, hashtags: [String])
   {
      self.object = object
      self.hashtags = hashtags
      
      super.init()
   }
   
   required convenience init?(coder aDecoder: NSCoder)
   {
      guard let object = aDecoder.decodeObjectForKey(kObjectKey) as? TWTRTweet else { return nil }
      guard let hashtags = aDecoder.decodeObjectForKey(kHashtagsKey) as? [String] else { return nil }
      
      self.init(object: object, hashtags: hashtags)
   }
   
   func encodeWithCoder(aCoder: NSCoder)
   {
      aCoder.encodeObject(object, forKey: kObjectKey)
      aCoder.encodeObject(hashtags, forKey: kHashtagsKey)
   }
}
