//
//  TwitterNetworkManager.swift
//  TweetMap
//
//  Created by GLR on 1/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import CoreLocation
import TwitterKit
import SwiftyJSON

class TwitterNetworkManager {
    
    
    static func findTrendingWoeIDForCoordinate(coordinate: CLLocationCoordinate2D, completion: ((woeID: String?) -> ())?)
    {
        let trendsShowEndpoint = "https://api.twitter.com/1.1/trends/closest.json"
        let params = ["lat": "\(coordinate.latitude)","long": "\(coordinate.longitude)"]
        
        var clientError: NSError?
        let client = TWTRAPIClient(userID: nil)
        let request = client.URLRequestWithMethod("GET", URL: trendsShowEndpoint, parameters: params, error: &clientError)
        
        if clientError == nil {
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                
                if connectionError == nil
                {
                    if let jsonData = data {
                        let json = JSON(data: jsonData)
                        if json.count > 0 {
                            let woeID = json[0]["woeid"].stringValue
                            
                            completion?(woeID: woeID)
                        }
                        else {
                            completion?(woeID: nil)
                        }
                    }
                }
                else {
                    print("Connection Error: \(connectionError?.description)")
                    completion?(woeID: nil)
                }
            }
        }
        else {
            print("Client Error: \(clientError?.description)")
            completion?(woeID: nil)
        }
    }
    
    
    static func getTweetsForCoordinate(coordinate: CLLocationCoordinate2D, radius: Int, completion: ((tweets: [Tweet]) -> ())?)
    {
        let searchTweetsEndpoint = "https://api.twitter.com/1.1/search/tweets.json"
        
        let coordinateString = "\(coordinate.latitude),\(coordinate.longitude)"
        let radiusString = "\(radius)mi"
        
        let geocodeString = "\(coordinateString),\(radiusString)"
        let query = "e OR t OR n OR o OR a OR i OR r OR s OR h OR l OR d OR c OR f OR u OR m OR y OR g OR p OR b OR v OR w OR k OR q OR j OR x OR z OR 0 OR 1 OR 2 OR 3 OR 4 OR 5 OR 6 OR 7 OR 8 OR 9"
        
        let params = ["q" : query, "geocode" : geocodeString, "count" : "100"]
        var clientError: NSError?
        let client = TWTRAPIClient(userID: nil)
        let request = client.URLRequestWithMethod("GET", URL: searchTweetsEndpoint, parameters: params, error: &clientError)
        
        if clientError == nil
        {
            client.sendTwitterRequest(request, completion: { (response, data, connectionError) -> Void in
                if connectionError == nil
                {
                    guard let jsonData = data else { return }
                    
                    let json = JSON(data: jsonData)
                    let statusesJSONArray = json["statuses"].array!
                    
//                    print(statusesJSONArray)
                    var tweetObjects: [Tweet] = []
                    
                    for status in statusesJSONArray
                    {
                        let text = status["text"].stringValue
                        let retweets = status["retweet_count"].intValue
                        var hashtagTextArray: [String] = []
                        
                        if let hashtags = status["entities"]["hashtags"].array {
                            for hashtag in hashtags
                            {
                                let hashtagText = hashtag["text"].stringValue
                                hashtagTextArray.append(hashtagText)
                            }
                        }
                        
                        let tweetObject = Tweet(text: text, retweets: retweets, hashtags: hashtagTextArray)
                        tweetObjects.append(tweetObject)
                    }
                    
                    completion?(tweets: tweetObjects)
                }
                else {
                    print("Connection Error: \(connectionError?.description)")
                }
            })
        }
    }
    
    static func getTrendsForWoeID(id: String, completion: ((trends: [Trend]) -> Void)?)
    {
        let trendsShowEndpoint = "https://api.twitter.com/1.1/trends/place.json"
        let params = ["id" : id]
        print("\(id)")
        var clientError: NSError?
        let client = TWTRAPIClient(userID: nil)
        let request = client.URLRequestWithMethod("GET", URL: trendsShowEndpoint, parameters: params, error: &clientError)
        
        if clientError == nil {
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                
                if connectionError == nil
                {
                    if let jsonData = data {
                        let json = JSON(data: jsonData)
                        if json.count > 0 {
                            
                            print(json[0]["locations"])
                            let trends = json[0]["trends"].array!
                            
                            var trendArray: [Trend] = []
                            for trendJSON in trends {
                                
                                let trendName = trendJSON["name"].stringValue
                                let trendVolume = trendJSON["tweet_volume"].intValue
                                let trend = Trend(name: trendName, tweetVolume: trendVolume)
                                
                                trendArray.append(trend)
                                
//                                trendArray.map({ trend in
//                                    
//                                })
                                
                                for each in trendArray  {
                                    if each.name.characters.first != "#"    {
                                        each.name = "#\(each.name)"
                                    }
                                }
                    
                            }
                            completion?(trends: trendArray)
                        }
                        else {
                            completion?(trends: [])
                        }
                    }
                }
                else {
                    print("Connection Error: \(connectionError?.description)")
                    completion?(trends: [])
                }
            }
        }
        else {
            print("Client Error: \(clientError?.description)")
            completion?(trends: [])
        }
    }
}
