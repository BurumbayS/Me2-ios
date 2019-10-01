//
//  WorkingHours.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/26/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import SwiftyJSON

struct WeekDay {
    var title: String
    var start: String
    var end: String
    var works: Bool
}

class WorkingHours {
    var weekDays = [WeekDay]()
    
    init(json: JSON) {
        for item in json.dictionaryValue {
            let title = item.key
            let start = item.value["start"].stringValue
            let end = item.value["end"].stringValue
            let works = item.value["works"].boolValue
            
            weekDays.append(WeekDay(title: title, start: start, end: end, works: works))
        }
    }
}

