//
//  ListViewCell.swift
//  TweetMap
//
//  Created by GLR on 1/5/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class ListViewCell: UITableViewCell {
    
    @IBOutlet weak var trendTitle: UILabel!
    @IBOutlet weak var trendDetail: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
