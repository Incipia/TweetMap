//
//  ContainerViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
   case Collapsed
   case Expanded
}

class ContainerViewController: UIViewController {
   
   var centerNavigationController: UINavigationController!
   var mapViewController: MapViewController!
   var sidePanelViewController: SidePanelViewController?
   
   var statusBarStyle: UIStatusBarStyle = .LightContent
   
   var currentState: SlideOutState = .Collapsed {
      didSet {
         let shouldShowShadow = currentState != .Collapsed
         showShadowForCenterViewController(shouldShowShadow)
      }
   }
   
   let centerPanelExpandedOffset: CGFloat = UIScreen.mainScreen().bounds.width * 0.5
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      mapViewController = UIStoryboard.centerViewController()
      
      // wrap the centerViewController in a navigation controller, so we can push views to it
      // and display bar button items in the navigation bar
      centerNavigationController = UINavigationController(rootViewController: mapViewController)
      view.addSubview(centerNavigationController.view)
      addChildViewController(centerNavigationController)
      
      centerNavigationController.didMoveToParentViewController(self)
      mapViewController.delegate = self
      
      //    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
      //    centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
   }
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle {
      return statusBarStyle
   }
}

extension ContainerViewController: UIGestureRecognizerDelegate {
   // MARK: Gesture recognizer
   
   func handlePanGesture(recognizer: UIPanGestureRecognizer) {
      let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
      
      switch(recognizer.state) {
      case .Began:
         if (currentState == .Collapsed) {
            if (gestureIsDraggingFromLeftToRight) {
               addLeftPanelViewController()
            }
            showShadowForCenterViewController(true)
         }
      case .Changed:
         
         guard recognizer.velocityInView(view).x > 0 else { return }
         
         recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
         recognizer.setTranslation(CGPointZero, inView: view)
      case .Ended:
         if (sidePanelViewController != nil) {
            // animate the side panel open or closed based on whether the view has moved more or less than halfway
            let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
            animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
         }
      default:
         break
      }
   }
   
}

private extension UIStoryboard {
   class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
   
   class func leftViewController() -> SidePanelViewController? {
      return mainStoryboard().instantiateViewControllerWithIdentifier("SidePanelViewController") as? SidePanelViewController
   }
   
   class func centerViewController() -> MapViewController? {
      return mainStoryboard().instantiateViewControllerWithIdentifier("MapViewController") as? MapViewController
   }
   
}

extension ContainerViewController: CenterViewControllerDelegate
{
   func updateTitleColor(color: UIColor)
   {
      centerNavigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : color]
   }
   
   func updateStatusBarStyle(style: UIStatusBarStyle)
   {
      statusBarStyle = style
      setNeedsStatusBarAppearanceUpdate()
   }
   
   //MARK: LEFT PANEL
   func toggleLeftPanel() {
      let notAlreadyExpanded = (currentState != .Expanded)
      
      if notAlreadyExpanded {
         addLeftPanelViewController()
      }
      
      animateLeftPanel(shouldExpand: notAlreadyExpanded)
   }
   
   func addLeftPanelViewController() {
      if (sidePanelViewController == nil) {
         sidePanelViewController = UIStoryboard.leftViewController()
         print(sidePanelViewController)
         
         addChildSidePanelController(sidePanelViewController!)
      }
   }
   
   func animateLeftPanel(shouldExpand shouldExpand: Bool) {
      if (shouldExpand) {
         currentState = .Expanded
         
         animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
      } else {
         animateCenterPanelXPosition(targetPosition: 0) { finished in
            self.currentState = .Collapsed
            self.sidePanelViewController!.view.removeFromSuperview()
            self.sidePanelViewController = nil;
         }
      }
   }
   
   
   //MARK: Misc / CENTER PANEL
   func addChildSidePanelController(sidePanelController: SidePanelViewController) {
      sidePanelController.delegate = mapViewController
      
      view.insertSubview(sidePanelController.view, atIndex: 0)
      
      addChildViewController(sidePanelController)
      sidePanelController.didMoveToParentViewController(self)
   }
   
   
   func animateCenterPanelXPosition(targetPosition targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
      UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
         self.centerNavigationController.view.frame.origin.x = targetPosition
         }, completion: completion)
   }
   
   
   func showShadowForCenterViewController(shouldShowShadow: Bool) {
      if (shouldShowShadow) {
         centerNavigationController.view.layer.shadowPath = UIBezierPath(rect: centerNavigationController.view.bounds).CGPath
         centerNavigationController.view.layer.shadowOpacity = 0.8
      } else {
         centerNavigationController.view.layer.shadowOpacity = 0.0
      }
   }
   
   func collapseSidePanel() {
      switch (currentState) {
      case .Expanded:
         toggleLeftPanel()
      case .Collapsed:
         toggleLeftPanel()
      }
   }
   
}