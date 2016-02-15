//
//  Tweet.swift
//  TweetMap
//
//  Created by GLR on 2/5/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import TwitterKit

class Tweet
{
    private(set) var object: TWTRTweet
    private(set) var hashtags: [String]
    private(set) var favoriteCount: Int
    private(set) var retweets: Int
    
    /*
    Consider adding favorite counter (another item returned with tweet data)
    This will allow for manipulating our network call depending on how the user wants to make their Trends 
    (with hashtags, retweets, or favorite count)
    */
    
    init(object: TWTRTweet, hashtags: [String], favoriteCount: Int, retweets: Int)
    {
        self.object = object
        self.hashtags = hashtags
        self.favoriteCount = favoriteCount
        self.retweets = retweets
    }
}
