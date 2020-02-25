//
//  Location.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 2/24/20.
//  Copyright © 2020 AVSoft. All rights reserved.
//

class Location {
    static var my = CLLocation()
    
    // calculate distance from my location in km with 1 item after point
    static func distance(from location: CLLocation) -> Double {
        let distance = my.distance(from: location)
        
        let distanceInkm = Double(Int(distance/100)) / 10
        
        return distanceInkm
    }
}
