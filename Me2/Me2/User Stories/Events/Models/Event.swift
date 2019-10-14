//
//  Event.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/24/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import SwiftyJSON

class Event {
    var title: String!
    var imageURL: String?
    var location = ""
    var everyday: Bool!
    var placeLogoURL: String?
    var eventType: String!
    
    init(json: JSON) {
        title = json["name"].stringValue
        imageURL = json["image"].stringValue
        eventType = json["event_type"].stringValue
        everyday = json["everyday"].boolValue
        placeLogoURL = json["place"]["logo"].stringValue
        location = json["place"]["name"].stringValue
    }
}
