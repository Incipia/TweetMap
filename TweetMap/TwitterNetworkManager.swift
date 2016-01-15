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
