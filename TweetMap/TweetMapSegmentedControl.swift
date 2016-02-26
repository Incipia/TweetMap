//
//  TweetMapSegmentedControl.swift
//  TweetMap
//
//  Created by Gregory Klein on 2/26/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class TweetMapSegmentedControl: UISegmentedControl
{
   override func awakeFromNib()
   {
      super.awakeFromNib()
   }
}

extension UISegmentedControl
{
   func updateTintColor(color: UIColor)
   {
      for subview in subviews {
         subview.tintColor = color
         for subsubview in subview.subviews {
            subsubview.tintColor = color
         }
      }
   }
}
