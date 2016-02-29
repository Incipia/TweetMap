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

class MaskLayer
{    
    func drawShadedRegion() -> CAShapeLayer {
        
        let fillLayer = CAShapeLayer()
        
        let size = UIScreen.mainScreen().bounds
        let rad: CGFloat = min(size.height, size.width)
        
        let path = UIBezierPath(roundedRect: CGRectMake(0, 0, size.width, size.height), cornerRadius: 0.0)
        
        let circlePath = UIBezierPath(roundedRect: CGRectMake(size.width/2.55-(rad/2.0), size.height/2.5-(rad/2.0), rad/0.81, rad/0.81), cornerRadius: rad)
        
        path.appendPath(circlePath)
        path.usesEvenOddFillRule = true
        
        fillLayer.path = path.CGPath
        fillLayer.fillRule = kCAFillRuleEvenOdd
        fillLayer.fillColor = UIColor(colorLiteralRed: 43.0/255, green: 30.0/255, blue: 52.0/255, alpha: 1).CGColor
        fillLayer.opacity = 0.17
        
        return fillLayer
    }
    
    func drawGradienForTopAndBottom() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = UIScreen.mainScreen().bounds
        
        let shadedColor = UIColor(colorLiteralRed: 43.0/255, green: 30.0/255, blue: 52.0/255, alpha: 0.55).CGColor
        
        let clearColor = UIColor.clearColor().CGColor
        
        gradientLayer.colors = [shadedColor, clearColor, clearColor, clearColor, clearColor, shadedColor]
        gradientLayer.locations = [0.0, 0.12, 0.3, 0.75, 0.85, 1]
        
        return gradientLayer
    }
}


