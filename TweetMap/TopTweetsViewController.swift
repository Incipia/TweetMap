//
//  TopTweetsViewController.swift
//  TweetMap
//
//  Created by GLR on 1/5/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class TopTweetsViewController: UITableViewController {
    
    var tweets = [Tweet]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)

        cell.textLabel!.text = tweets[indexPath.row].text

        return cell
    }
    

}
