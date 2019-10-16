//
//  Event.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/24/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import SwiftyJSON

enum DateType: String {
    case weekdays = "WEEKDAYS"
    case everyday = "EVERYDAY"
    
    var title: String {
        switch self {
        case .weekdays:
            return "Будни"
        case .everyday:
            return "Ежедневно"
        }
    }
}

class Event {
    let id: Int
    var title: String!
    var imageURL: String?
    var place: Place!
    var eventType: String!
    var start: String?
    var end: String?
    var time_start: String?
    var time_end: String?
    var date_type: DateType!
    
    init(json: JSON) {
        id = json["id"].intValue
        title = json["name"].stringValue
        imageURL = json["image"].stringValue
        eventType = json["event_type"]["name"].stringValue
        place = Place(json: json["place"])
        date_type = DateType(rawValue: json["date_type"].stringValue)
        start = json["start"].stringValue
        end = json["end"].stringValue
        time_start = json["time_start"].stringValue
        time_end = json["time_end"].stringValue
    }
    
    func getTime() -> String {
        var start = time_start ?? ""
        var end = time_end ?? ""
        
        if start != "" && end != "" {
            start.removeLast(3)
            end.removeLast(3)
            
            return date_type.title + " " + start + "-" + end
        }
        
        if end != "" {
            end.removeLast(3)

            return date_type.title + " до " + end
        }
        
        if start != "" {
            start.removeLast(3)
            
            return date_type.title + " с " + start
        }
        
        return date_type.title
    }
}
