//
//  ZoomLevelTableViewDataSource.swift
//  TweetMap
//
//  Created by GLR on 1/4/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class ZoomLevelTableViewDataSource: NSObject
{
    private let _tableView: UITableView
    private let _testData = ["test - one", "test - two", "test - three"]
    
    // MARK: - Init
    init(tableView: UITableView)    {
        
        _tableView = tableView
        super.init()
        _tableView.dataSource = self
    }
}

// MARK: - UITableView Data Source
extension ZoomLevelTableViewDataSource: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return _testData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        cell.textLabel?.text = _testData[indexPath.row]
        return cell
    }
}