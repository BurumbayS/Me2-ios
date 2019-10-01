//
//  PlacePin.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/19/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class PlacePin {
    var id: Int!
    var name: String!
    var longitude: Double!
    var latitude: Double!

    static func convert(from json: JSON) -> PlacePin {
        let placePin = PlacePin()
    
        placePin.id = json["id"].intValue
        placePin.name = json["name"].stringValue
        placePin.longitude = json["location"]["longitude"].doubleValue
        placePin.latitude = json["location"]["latitude"].doubleValue
        
        return placePin
    }
    
}
