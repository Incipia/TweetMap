//
//  ListTrendsViewController.swift
//  TweetMap
//
//  Created by GLR on 1/4/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class ListTrendsViewController: UITableViewController {
    
    var trends = [Trend]()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("view loading")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("View will appear")
        configureTableView()
        
//        UINavigationBar.appearance().barTintColor = UIColor.lightGrayColor()
////        UINavigationBar.appearance().tintColor = UIColor.blackColor()
//        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().translucent = false
//        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trends.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ListViewCell

        cell.trendTitle.text = trends[indexPath.row].name
        cell.trendDetail.text = "\(trends[indexPath.row].tweetVolume)"

        return cell
    }
    
    func configureTableView() {
        print("Table view configuring")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = (self.view.bounds.height - (self.navigationController?.navigationBar.bounds.height)!)/5.125
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
