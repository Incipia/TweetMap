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
    var centerViewController: MapViewController!
    var leftViewController: SidePanelViewController?
    
    var currentState: SlideOutState = .Collapsed {
        didSet {
            let shouldShowShadow = currentState != .Collapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    
    let centerPanelExpandedOffset: CGFloat = 120
  
  override func viewDidLoad() {
    super.viewDidLoad()
    centerViewController = UIStoryboard.centerViewController()
    centerViewController.delegate = self
    
    // wrap the centerViewController in a navigation controller, so we can push views to it
    // and display bar button items in the navigation bar
    centerNavigationController = UINavigationController(rootViewController: centerViewController)
    view.addSubview(centerNavigationController.view)
    addChildViewController(centerNavigationController)
    
    centerNavigationController.didMoveToParentViewController(self)
    
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
    centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
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
            recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
            recognizer.setTranslation(CGPointZero, inView: view)
        case .Ended:
            if (leftViewController != nil) {
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

extension ContainerViewController: CenterViewControllerDelegate {
    
    
    //MARK: LEFT PANEL
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .Expanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func addLeftPanelViewController() {
        if (leftViewController == nil) {
            leftViewController = UIStoryboard.leftViewController()
            print(leftViewController)
            
            addChildSidePanelController(leftViewController!)
        }
    }
    
    func animateLeftPanel(shouldExpand shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .Expanded
            
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .Collapsed
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil;
            }
        }
    }
    
    
    //MARK: Misc / CENTER PANEL
    func addChildSidePanelController(sidePanelController: SidePanelViewController) {
        sidePanelController.delegate = centerViewController
        
        view.insertSubview(sidePanelController.view, atIndex: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    
    func animateCenterPanelXPosition(targetPosition targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }

    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
    func collapseSidePanels() {
        switch (currentState) {
        case .Expanded:
            toggleLeftPanel()
        case .Collapsed:
            toggleLeftPanel()
        default:
            break
        }
    }
    
}