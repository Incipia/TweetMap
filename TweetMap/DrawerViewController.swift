//
//  DrawerViewController.swift
//  TweetMap
//
//  Created by GLR on 12/28/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController, SlideMenuDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func slideMenuItemSelectedAtIndex(index: Int32) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index){
        case 0:
            print("case 0")
            break
        case 1:
            print("case 1")
            break
        case 2:
            print("case 2")
            break
        default:
            print("default")
        }
    }
    
    func addSlideMenuButton(){
        let btnShowMenu = UIButton(type: UIButtonType.System)
        btnShowMenu.setImage(self.defaultMenuImage(), forState: UIControlState.Normal)
        btnShowMenu.frame = CGRectMake(0, 0, 30, 30)
        btnShowMenu.addTarget(self, action: "onSlideMenuButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        customBarItem.tintColor = UIColor.redColor()
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        struct Static {
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken, { () -> Void in
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), false, 0.0)
            
//            UIColor.blackColor().setFill()
//            UIBezierPath(rect: CGRectMake(0, 3, 30, 2)).fill()
//            UIBezierPath(rect: CGRectMake(0, 10, 30, 2)).fill()
//            UIBezierPath(rect: CGRectMake(0, 17, 30, 2)).fill()
//
            UIColor.whiteColor().setFill()
            UIBezierPath(rect: CGRectMake(0, 4, 30, 2)).fill()
            UIBezierPath(rect: CGRectMake(0, 13,  30, 2)).fill()
            UIBezierPath(rect: CGRectMake(0, 22, 30, 2)).fill()
//
            defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
        })
        
        return defaultMenuImage;
    }
    
    func onSlideMenuButtonPressed(sender : UIButton){
        
        self.view.backgroundColor = UIColor(red: 255.0/255.0,
            green: 255.0/255.0,
            blue: 255.0/255.0,
            alpha: 0.3)

        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.mainScreen().bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.backgroundColor = UIColor.clearColor()

                }, completion: { (finished) -> Void in
                    viewMenuBack.removeFromSuperview()
            })
            
            return
        }
  
        sender.enabled = false
        sender.tag = 10

        let menuVC : SlideMenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SlideMenuViewController") as! SlideMenuViewController
        
        menuVC.btnMenu = sender

        menuVC.delegate = self
        
        self.view.backgroundColor = UIColor(red: 255.0/255.0,
            green: 255.0/255.0,
            blue: 255.0/255.0,
            alpha: 0.3)

        self.view.addSubview(menuVC.view)

        self.addChildViewController(menuVC)

        menuVC.view.frame=CGRectMake(0 - UIScreen.mainScreen().bounds.size.width, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height);

        UIView.animateWithDuration(0.3, animations: { () -> Void in
            menuVC.view.frame=CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height);
            sender.enabled = true
            self.view.backgroundColor = UIColor(red: 0.0,
                green: 0.0,
                blue: 0.0,
                alpha: 0.3)
            }, completion:nil)

    }

}
