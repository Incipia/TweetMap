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
    var selectedIndex = Int()

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
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default// I then set the color using:
        
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
//        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor.blackColor()
//        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        
        
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor() // for titles, buttons, etc.
        let navigationTitleFont = UIFont(name: "Helvetica Neue", size: 20)!
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationTitleFont, NSForegroundColorAttributeName: UIColor.blackColor() ]
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
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = (self.view.bounds.height/10)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        let indexPath = tableView.indexPathForSelectedRow
        _ = tableView.cellForRowAtIndexPath(indexPath!)
        self.performSegueWithIdentifier("listDetail", sender: nil)
    }


    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "listDetail"    {
            let destVC = segue.destinationViewController as! TopTweetsViewController
            destVC.navigationItem.title = trends[selectedIndex].name
            print("\(trends[selectedIndex].name)")
        }
    }

}
