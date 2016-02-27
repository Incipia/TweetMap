//
//  ZoomLevelTableViewDelegate.swift
//  TweetMap
//
//  Created by GLR on 1/4/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class ZoomLevelTableViewDelegate: NSObject {

    private let _tableView: UITableView
    var rowSelectionHandler: ((indexPath: NSIndexPath) -> Void)?
    
    init(tableView: UITableView)
    {
        _tableView = tableView
        super.init()
        _tableView.delegate = self
    }
}

extension ZoomLevelTableViewDelegate: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        rowSelectionHandler?(indexPath: indexPath)
    }
}
