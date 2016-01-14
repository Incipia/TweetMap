//
//  Woe.swift
//  twitterCall
//
//  Created by GLR on 1/7/16.
//  Copyright © 2016 George Royce. All rights reserved.
//

import Foundation
import UIKit

class Woe   {
    
//    static let sharedInstance = Woe()
    
    var woeID = String()
    var city = String()
    var county = String()
    var state = String()
    
    
    
    init(woeID: String, city: String, county: String, state: String)  {
        self.woeID = woeID
        self.city = city
        self.county = county
        self.state = state
    }
    
    
    
}
