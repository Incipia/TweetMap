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

class TwitterNetworkManager
{
   static func getTweetsForLocation(location: CLLocation, radius: Int, completion: ((tweets: [TWTRTweet]) -> Void)?)
   {
      let searchTweetsEndpoint = "https://api.twitter.com/1.1/search/tweets.json"
      
      let coordinateString = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
      
      let radiusString = "\(radius)mi"
      
      let geocodeString = "\(coordinateString),\(radiusString)"
      print(geocodeString)
      
      let query = "-filter:retweets -job -Job -jobs -Jobs -Hiring -hiring"
      
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
               guard let JSONArray = json["statuses"].arrayObject else { return }
               guard let tweetObjects: [TWTRTweet] = TWTRTweet.tweetsWithJSONArray(JSONArray) as? [TWTRTweet] else { return }
               
               completion?(tweets: tweetObjects)
            }
            else {
               print("Connection Error: \(connectionError?.description)")
            }
         })
      }
   }
   
   static func getTweetsForCoordinate(coordinate: CLLocationCoordinate2D, radius: Int, completion: ((tweets: [Tweet]) -> ())?)
   {
      let searchTweetsEndpoint = "https://api.twitter.com/1.1/search/tweets.json"
      let coordinateString = "\(coordinate.latitude),\(coordinate.longitude)"
      let radiusString = "\(radius)mi"
      let geocodeString = "\(coordinateString),\(radiusString)"
      let query = "-filter:retweets -filter:links -tweet -Tweet -job -Job -jobs -Jobs -Hiring -hiring -nyc -NYC -Nyc"
      
      let params = ["geocode" : geocodeString, "count" : "100", "q" : query]
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
               guard let JSONArray = json["statuses"].arrayObject else { return }
               guard let tweetObjects: [TWTRTweet] = TWTRTweet.tweetsWithJSONArray(JSONArray) as? [TWTRTweet] else { return }
               
               guard let statusesJSONArray = json["statuses"].array else { return }
               
               var tweets: [Tweet] = []
               for status in statusesJSONArray
               {
                  var hashtagTextArray: [String] = []
                  
                  if let hashtags = status["entities"]["hashtags"].array {
                     for hashtag in hashtags
                     {
                        let hashtagText = hashtag["text"].stringValue
                        hashtagTextArray.append(hashtagText)
                     }
                     
                     let id = status["id"].stringValue
                     if let tweetObject = tweetObjects.filter({$0.tweetID == id}).first {
                        let tweet = Tweet(object: tweetObject, hashtags: hashtagTextArray)
                        tweets.append(tweet)
                     }
                  }
               }
               completion?(tweets: tweets)
            }
            else {
               print("Connection Error: \(connectionError?.description)")
            }
         })
      }
   }
}
