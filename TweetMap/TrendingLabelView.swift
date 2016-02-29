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

protocol TrendingLabelViewDelegate: class
{
   func trendingLabelViewTrendTapped(trend: Trend)
}

class TrendingLabelView: UIView
{
   @IBOutlet private weak var _heightConstraint: NSLayoutConstraint!
   @IBOutlet private weak var _widthConstraint: NSLayoutConstraint!
   
   @IBOutlet private weak var _nameLabel: UILabel!
   
   private let _tapRecognizer = UITapGestureRecognizer()
   private weak var _trend: Trend?
   weak var delegate: TrendingLabelViewDelegate?
   
   override func awakeFromNib()
   {
      super.awakeFromNib()
      
      backgroundColor = backgroundColor?.colorWithAlphaComponent(0.95)
      layer.cornerRadius = 4.0
      
      _nameLabel.text = "#HASHTAG"
      
      _tapRecognizer.addTarget(self, action: "viewTapped:")
      addGestureRecognizer(_tapRecognizer)
   }
   
   internal func viewTapped(recognizer: UIGestureRecognizer)
   {
      guard let trend = _trend else { return }
      delegate?.trendingLabelViewTrendTapped(trend)
   }
   
   func updateWithTrend(trend: Trend)
   {
      _trend = trend
      
      _nameLabel.text = "#\(trend.name)"
      
      _nameLabel.sizeToFit()
      
      let textLabelWidth = _nameLabel.frame.width
      let sidePadding: CGFloat = 10
      
      let newWidth = textLabelWidth + sidePadding * 2
      _widthConstraint.constant = max(newWidth, 80)
      
      UIView.animateWithDuration(0.15, animations: { () -> Void in
         self.layoutIfNeeded()
         }) { (finished) -> Void in
            self.hidden = false
      }
   }
}
