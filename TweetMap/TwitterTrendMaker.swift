//
//  DataParser.swift
//  TweetMap
//
//  Created by GLR on 2/16/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit
import CoreLocation

class TwitterTrendMaker    {
    
    var tweets: [Tweet]?
    var trends: [Trend]?
//    var coordinate: CLLocationCoordinate2D?
//    var metricSystem: Bool?
//    var radius:
    
    //MARK: NETWORK CALL
    func makeTrendFromTwitterCall(coordinate: CLLocationCoordinate2D, metricSystem: Bool, radius: Int)
    {
        TwitterNetworkManager.getTweetsForCoordinate(coordinate, metricSystem: metricSystem, radius: radius) { incomingTweets -> () in
            
            var hashtagFrequencyDictionary: [String: Int] = [:]
            var tempTrends: [Trend] = []
            
            // for each tweet, go through all the hashtags and populate the hashtagFrequencyDictionary with correct info
            for tweet in incomingTweets
            {
                for hashtag in tweet.hashtags
                {
                    if let hashtagCount = hashtagFrequencyDictionary[hashtag] {
                        hashtagFrequencyDictionary[hashtag] = hashtagCount + 1
                    }
                    else {
                        hashtagFrequencyDictionary[hashtag] = 1
                    }
                }
            }
            
            // for each hashtag in the frequency dictionary, get the count and create a trend object
            for hashtag in hashtagFrequencyDictionary.keys
            {
                let name = hashtag
                let count = hashtagFrequencyDictionary[hashtag]!
                
                let trend = Trend(name: name, tweetVolume: count)
                for tweet in incomingTweets {
                    if tweet.hashtags.contains(hashtag) {
                        trend.tweets.append(tweet)
                    }
                }
                tempTrends.append(trend)
            }
            self.tweets = incomingTweets
            self.trends = tempTrends
            self.tallyTrends()
            for each in self.tweets!  {
                print(each.hashtags)
            }
            for each in self.trends! {
                print(each.name, each.tweetVolume)
            }
        }
    }
    
    
    func tallyTrends()  {
        if trends!.count < 5 {
            print("not enough trends to display")
        } else  {
            trends!.sortInPlace({$0.0.tweetVolume > $0.1.tweetVolume})
        }
        
    }
    
    
    
    
    
    
}








