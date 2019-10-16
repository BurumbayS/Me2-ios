//
//  DateExtension.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/9/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

extension Date {
    
    func dayOfTheWeek() -> String? {
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]
        
        let calendar = Calendar.current
        let component = calendar.component(.weekday, from: self)
        return weekdays[component - 1].lowercased()
    }
    
    func currentTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru")
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: self)
    }
}
