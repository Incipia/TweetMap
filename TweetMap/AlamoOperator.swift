//
//  AlamoOperator.swift
//  twitterCall
//
//  Created by GLR on 1/7/16.
//  Copyright © 2016 George Royce. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class AlamoOperation    {
    
    var woeID = String()
    var parentWoeID = String()
    var woe: Woe?
    
    let postEndpoint: URLStringConvertible
    
    func ringRingWoe()  {
        
        Alamofire.request(.GET, postEndpoint).responseSwiftyJSON({ (request, response, json, error) in
            
            print(json)
            
                guard let woeid = json["query"]["results"]["Result"]["woeid"].string else {
                    print("original woeid \(error)")
                    return
                }
            
                guard let city = json["query"]["results"]["Result"]["city"].string else {
                    print("\(error)")
                    return
                }
            
                guard let state = json["query"]["results"]["Result"]["state"].string else {
                    print("\(error)")
                    return
                }
            
                guard let county = json["query"]["results"]["Result"]["county"].string else {
                    print("\(error)")
                    return
                }
                
                self.woe = Woe(woeID: woeid, city: city, county: county, state: state)
            
                print("Woe from data model: \(self.woe!.woeID) : \(self.woe!.city) : \(self.woe!.state) : \(self.woe!.county)")
            

            })
    }
    
    func parentRingRing()   {
        Alamofire.request(.GET, postEndpoint).responseSwiftyJSON({ (request, response, json, error) in
                print(json)
                print(error)
            })

    }
    
    
    init(postEndpoint: URLStringConvertible)  {
        self.postEndpoint = postEndpoint
    }
    
    
    
    
    
    
    
    
}
