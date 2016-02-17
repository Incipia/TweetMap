//
//  Dropdown.swift
//  TweetMap
//
//  Created by GLR on 2/16/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import BTNavigationDropdownMenu
import UIKit

class Dropdown {
    
    var navController: UINavigationController?
    var navItem: UINavigationItem?
    
    init(navController: UINavigationController?, navItem: UINavigationItem?)    {
        self.navController = navController
        self.navItem = navItem
    }
    
    
    func create() {
        let items = ["Hashtags", "Nearby"]
        
        let menuView = BTNavigationDropdownMenu(navigationController: self.navController,
            title: items.first!, items: items)
        
        navItem!.titleView = menuView
        
        print(navController)
        print(menuView)
        
        
        //cell config
        menuView.cellBackgroundColor = UIColor.darkGrayColor()
        menuView.cellSeparatorColor = UIColor.whiteColor()
        menuView.cellTextLabelFont = UIFont(name: "Helvetica Neue", size: 20)
        menuView.cellTextLabelColor = UIColor.whiteColor()
        menuView.cellTextLabelAlignment = NSTextAlignment.Center
        
        //What to do with option selected by user from dropdown menu
        menuView.didSelectItemAtIndexHandler = { indexPath in
            switch indexPath    {
            case 0:
                print("picked first choice")
            case 1:
                print("picked second choice")
            default:
                break
            }
        }
    }
    
}
