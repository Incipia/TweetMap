//
//  ListTrendsViewController.swift
//  TweetMap
//
//  Created by GLR on 1/6/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class ListTrendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var trendsTableView: UITableView!

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
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
        let navigationTitleFont = UIFont(name: "Helvetica Neue", size: 20)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationTitleFont, NSForegroundColorAttributeName: UIColor.blackColor() ]
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trends.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ListViewCell
        
        cell.trendTitle.text = trends[indexPath.row].name
        cell.trendDetail.text = "\(trends[indexPath.row].tweetVolume)"
        
        return cell
    }
    
    func configureTableView() {
        trendsTableView.rowHeight = UITableViewAutomaticDimension
        trendsTableView.rowHeight = (self.view.bounds.height/10)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
