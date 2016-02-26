//
//  TrendingLabelView.swift
//  TweetMap
//
//  Created by Gregory Klein on 2/26/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

private let TrendingTextFont = UIFont.systemFontOfSize(15)
private let TrendingCountFont = UIFont.systemFontOfSize(12)

class TrendingLabelView: UIView
{
   @IBOutlet private weak var _heightConstraint: NSLayoutConstraint!
   @IBOutlet private weak var _widthConstraint: NSLayoutConstraint!
   
   private let _trendingTextLabel: UILabel = UILabel()
   private let _trendingCountLabel: UILabel = UILabel()
   
   override func awakeFromNib()
   {
      super.awakeFromNib()
      
      layer.cornerRadius = 2.0
      
      _trendingTextLabel.font = TrendingTextFont
      _trendingTextLabel.textColor = UIColor.whiteColor()
      
      _trendingCountLabel.font = TrendingCountFont
      _trendingCountLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
      
      _trendingTextLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
      _trendingCountLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
      
      addSubview(_trendingTextLabel)
      addSubview(_trendingCountLabel)
   }
   
   func updateWithTrend(trend: Trend)
   {
      _trendingTextLabel.text = "#\(trend.name)"
      _trendingCountLabel.text = "\(trend.tweetVolume)"
      
      _trendingTextLabel.sizeToFit()
      _trendingCountLabel.sizeToFit()
      
      let textLabelWidth = _trendingTextLabel.frame.width
      let textLabelHeight = _trendingTextLabel.frame.height
      
      let countLabelWidth = _trendingCountLabel.frame.width
      let countLabelHeight = _trendingCountLabel.frame.height
      
      let totalLabelHeight = textLabelHeight + countLabelHeight
      let topPadding: CGFloat = 10
      let middlePadding: CGFloat = 5
      let bottomPadding: CGFloat = 10
      let sidePadding: CGFloat = 10
      
      _heightConstraint.constant = totalLabelHeight + topPadding + middlePadding + bottomPadding
      let newWidth = max(textLabelWidth, countLabelWidth) + sidePadding * 2
      _widthConstraint.constant = max(newWidth, 100)
      
      UIView.animateWithDuration(0.15) { () -> Void in
         self.layoutIfNeeded()
      }
   }
   
   override func layoutSubviews() {
      super.layoutSubviews()
      
      let textLabelHeight = _trendingTextLabel.frame.height
      let countLabelHeight = _trendingCountLabel.frame.height
      let middlePadding: CGFloat = 5
      
      _trendingTextLabel.center = CGPoint(x: bounds.midX, y: bounds.midY - textLabelHeight * 0.5 - middlePadding * 0.5)
      
      _trendingCountLabel.center = CGPoint(x: bounds.midX, y: bounds.midY + countLabelHeight * 0.5 + middlePadding * 0.5)
   }
}
