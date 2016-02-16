//
//  MaskLayer.swift
//  TweetMap
//
//  Created by GLR on 2/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

class MaskLayer {
    
    func drawShadedRegion() -> CAShapeLayer {
        
        let fillLayer = CAShapeLayer()
        fillLayer.fillColor = UIColor.grayColor().CGColor
        
        let size = UIScreen.mainScreen().bounds
        let rad: CGFloat = min(size.height, size.width)
        
        let path = UIBezierPath(roundedRect: CGRectMake(0, 0, size.width, size.height), cornerRadius: 0.0)
        
        let circlePath = UIBezierPath(roundedRect: CGRectMake(size.width/2.55-(rad/2.0), size.height/2.5-(rad/2.0), rad/0.81, rad/0.81), cornerRadius: rad)
        
        path.appendPath(circlePath)
        path.usesEvenOddFillRule = true
        
        fillLayer.path = path.CGPath
        fillLayer.fillRule = kCAFillRuleEvenOdd
        fillLayer.fillColor = UIColor.grayColor().CGColor
        fillLayer.opacity = 0.7
        
        return fillLayer
    }
    
    func drawGradienForTopAndBottom() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = UIScreen.mainScreen().bounds
        
        let color1 = UIColor.grayColor().CGColor as CGColorRef
        let color2 = UIColor.clearColor().CGColor as CGColorRef
        let color3 = UIColor.clearColor().CGColor as CGColorRef
        let color4 = UIColor.grayColor().CGColor as CGColorRef
        
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0, 0.11, 0.89, 1]
        
        return gradientLayer
    }
}


