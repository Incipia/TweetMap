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

class TwitterTrendMaker
{
   var tweets: [Tweet]?
   var trends: [Trend]?
   var phraseTrends: [PhraseTrend]?
   //    var coordinate: CLLocationCoordinate2D?
   //    var metricSystem: Bool?
   //    var radius:
   
   func getTrendingPhrasesForLocation(location: CLLocation, radius: Int, completion: ((phraseTrends: [PhraseTrend]) -> Void)?)
   {
      
      SwiftSpinner.show("Getting Trends...", animated: true)
      TwitterNetworkManager.getTweetsForLocation(location, radius: radius) { (tweets) -> Void in
         
         var phraseTweetDictionary: [String : [TWTRTweet]] = [:]
         
         print("TOTAL TWEETS: \(tweets.count)")
         let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
         dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            
            for tweet in tweets {
               let phraseList = self._getPhrasesFromText(tweet.text)
               for phrase in phraseList
               {
                  if var trendingTweets = phraseTweetDictionary[phrase] {
                     trendingTweets.append(tweet)
                     phraseTweetDictionary[phrase] = trendingTweets
                  }
                  else {
                     if self._phraseIsValid(phrase) {
                        phraseTweetDictionary[phrase] = [tweet]
                     }
                     else {
                        print("phrase is ALL stopwords: \(phrase)")
                     }
                  }
               }
            }
            
            var phraseTrends: [PhraseTrend] = []
            for phrase in phraseTweetDictionary.keys {
               
               let phraseTrend = PhraseTrend(phrase: phrase, tweets: phraseTweetDictionary[phrase]!)
               phraseTrends.append(phraseTrend)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
               SwiftSpinner.hide({ () -> Void in
                  completion?(phraseTrends: phraseTrends)
               })
               // update some UI
            }
         }
      }
   }
   
   private func _phraseIsValid(phrase: String) -> Bool
   {
      let wordsArray = phrase.characters.split{$0 == " "}.map(String.init)
      guard wordsArray.count >= 2 else { return false }
      
      var stopWordsCount = 0
      
      for word in wordsArray
      {
         var normalizedWord = word.lowercaseString
         
         let unsafeChars = NSCharacterSet.alphanumericCharacterSet().invertedSet
         normalizedWord = normalizedWord.componentsSeparatedByCharactersInSet(unsafeChars).joinWithSeparator("")
         
         if _stopWords.contains(normalizedWord) {
            ++stopWordsCount
         }
      }
      
      if phrase == "@" {
         return false
      }
      
      if phrase == "I'm" {
         return false
      }
      
      let valid = stopWordsCount != wordsArray.count
      return valid
   }
   
   private func _getPhrasesFromText(text: String) -> [String]
   {
      var phrases: [String] = []
      
      let wordsArray = text.characters.split{$0 == " "}.map(String.init)
      
      for wordIndex in 0..<wordsArray.count {
         
         var phrase = wordsArray[wordIndex]
         phrases.append(phrase)
         
         for innerWordIndex in wordIndex+1..<wordsArray.count {
            phrase = "\(phrase) \(wordsArray[innerWordIndex])"
            phrases.append(phrase)
         }
      }
      
      return phrases
   }
   
   //MARK: NETWORK CALL
   func makeTrendFromTwitterCall(coordinate: CLLocationCoordinate2D, radius: Int, completion: ((tweets: [Tweet], trends: [Trend]) -> Void)?)
   {
      TwitterNetworkManager.getTweetsForCoordinate(coordinate, radius: radius) { incomingTweets -> () in
         
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
         
         completion?(tweets: incomingTweets, trends: tempTrends)
         
//         for each in self.tweets! {
//            print(each.hashtags, each.object.text)
//         }
         
         for each in self.trends! {
            print(each.name, each.tweetVolume)
         }
      }
   }
   
   func tallyTrends()
   {
      if trends!.count < 5 {
         print("not enough trends to display")
      }
      else {
         trends!.sortInPlace({$0.0.tweetVolume > $0.1.tweetVolume})
      }
   }
}

private let _stopWords = ["a", "about", "above", "above", "across", "after", "afterwards", "again", "against", "all", "almost", "alone", "along", "already", "also","although","always","am","among", "amongst", "amoungst", "amount",  "an", "and", "another", "any","anyhow","anyone","anything","anyway", "anywhere", "are", "around", "as",  "at", "back","be","became", "because","become","becomes", "becoming", "been", "before", "beforehand", "behind", "being", "below", "beside", "besides", "between", "beyond", "bill", "both", "bottom","but", "by", "call", "can", "cannot", "cant", "co", "con", "could", "couldnt", "cry", "de", "describe", "detail", "do", "done", "down", "due", "during", "each", "eg", "eight", "either", "eleven","else", "elsewhere", "empty", "enough", "etc", "even", "ever", "every", "everyone", "everything", "everywhere", "except", "few", "fifteen", "fify", "fill", "find", "fire", "first", "five", "for", "former", "formerly", "forty", "found", "four", "from", "front", "full", "further", "get", "give", "go", "had", "has", "hasnt", "have", "he", "hence", "her", "here", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "him", "himself", "his", "how", "however", "hundred", "ie", "if", "in", "inc", "indeed", "interest", "into", "is", "it", "its", "itself", "keep", "last", "latter", "latterly", "least", "less", "ltd", "made", "many", "may", "me", "meanwhile", "might", "mill", "mine", "more", "moreover", "most", "mostly", "move", "much", "must", "my", "myself", "name", "namely", "neither", "never", "nevertheless", "next", "nine", "no", "nobody", "none", "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", "often", "on", "once", "one", "only", "onto", "or", "other", "others", "otherwise", "our", "ours", "ourselves", "out", "over", "own","part", "per", "perhaps", "please", "put", "rather", "re", "same", "see", "seem", "seemed", "seeming", "seems", "serious", "several", "she", "should", "show", "side", "since", "sincere", "six", "sixty", "so", "some", "somehow", "someone", "something", "sometime", "sometimes", "somewhere", "still", "such", "system", "take", "ten", "than", "that", "their", "them", "themselves", "then", "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon", "these", "they", "thickv", "thin", "third", "this", "those", "though", "three", "through", "throughout", "thru", "thus", "to", "together", "too", "top", "toward", "towards", "twelve", "twenty", "two", "un", "under", "until", "up", "upon", "us", "very", "via", "was", "we", "well", "were", "what", "whatever", "when", "whence", "whenever", "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "whoever", "whole", "whom", "whose", "why", "will", "with", "within", "without", "would", "yet", "you", "your", "yours", "yourself", "yourselves", "the", "@", "I'm", "I"]