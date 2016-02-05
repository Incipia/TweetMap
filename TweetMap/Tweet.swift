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
    
    init(object: TWTRTweet, hashtags: [String])
    {
        self.object = object
        self.hashtags = hashtags
    }
}
