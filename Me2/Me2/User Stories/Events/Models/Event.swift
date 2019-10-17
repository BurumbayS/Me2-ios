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
    case once = "ONCE"
    
    var title: String {
        switch self {
        case .weekdays:
            return "Будни"
        case .everyday:
            return "Ежедневно"
        case .once:
            return ""
        }
    }
}

class Event {
    let id: Int
    var title: String!
    var description: String?
    var imageURL: String?
    var place: Place!
    var eventType: String!
    var start: String!
    var end: String!
    var time_start: String?
    var time_end: String?
    var date_type: DateType!
    var tags = [String]()
    
    init(json: JSON) {
        id = json["id"].intValue
        title = json["name"].stringValue
        description = json["description"].stringValue
        imageURL = json["image"].stringValue
        eventType = json["event_type"]["name"].stringValue
        place = Place(json: json["place"])
        date_type = DateType(rawValue: json["date_type"].stringValue)
        start = json["start"].stringValue
        end = json["end"].stringValue
        time_start = json["time_start"].stringValue
        time_end = json["time_end"].stringValue
        
        for item in json["tags"].arrayValue {
            tags.append(item.stringValue)
        }
    }
    
    func getTime() -> String {
        if date_type == .once {
            return "\(formatDate(str: start))-\(formatDate(str: end))"
        }
        
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
    
    private func formatDate(str: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let date = formatter.date(from: str)
        
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date!)
    }
}
