//
//  Utilities.swift
//  TweetMap
//
//  Created by GLR on 1/4/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

extension PopoverOption {
    static var defaultOptions: [PopoverOption]  {
        return [
            .Type(.Up),
            .CornerRadius(4.0),
            .AnimationIn(0.5),
            .ArrowSize(CGSizeMake(10.0, 10.0))
        ]
    }
}

extension String {
    
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
}
