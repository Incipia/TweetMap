//
//  TopTweetsViewController.swift
//  TweetMap
//
//  Created by GLR on 1/5/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import TwitterKit


class TopTweetsViewController: UITableViewController, TWTRTweetViewDelegate {
   
   let tweetTableReuseIdentifier = "TweetCell"
   
   private var _tweets: [Tweet] = [] {
      didSet {
         tableView.reloadData()
      }
   }
   
   func configureWithTweets(tweets: [Tweet])
   {
      _tweets = tweets
   }
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      _setupTableView()
   }
   
   override func viewDidAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
      self.navigationController?.navigationBar.translucent = false
   }
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle
   {
      return .Default
   }
   
   private func _setupTableView()
   {
      tableView.estimatedRowHeight = 150
      tableView.rowHeight = UITableViewAutomaticDimension // Explicitly set on iOS 8 if using automatic row height calculation
      tableView.allowsSelection = false
      tableView.registerClass(TWTRTweetTableViewCell.self, forCellReuseIdentifier: tweetTableReuseIdentifier)
   }
   
   // MARK: UITableViewDelegate Methods
   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      return _tweets.count
   }
   
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell = tableView.dequeueReusableCellWithIdentifier(tweetTableReuseIdentifier, forIndexPath: indexPath) as! TWTRTweetTableViewCell
      
      let tweet = _tweets[indexPath.row].object
      cell.configureWithTweet(tweet)
      cell.tweetView.delegate = self
      
      return cell
   }
   
   override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
   {
      let tweet = _tweets[indexPath.row].object
      return TWTRTweetTableViewCell.heightForTweet(tweet, width: CGRectGetWidth(self.view.bounds))
   }
}
