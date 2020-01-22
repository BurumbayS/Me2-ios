//
//  DateExtension.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/9/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

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
    
    func isToday() -> Bool {
        let today = Date()
        
        let order = Calendar.current.compare(today, to: self, toGranularity: .day)
        return order == .orderedSame
    }
    
    func isYesterday() -> Bool {
        let today = Date()
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today) else { return false }
        
        let order = Calendar.current.compare(yesterday, to: self, toGranularity: .day)
        return order == .orderedSame
    }
    
    func isEqual(to date: Date) -> Bool {
        let order = Calendar.current.compare(date, to: self, toGranularity: .day)
        return order == .orderedSame
    }
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        let stringDate = dateFormatter.string(from: self)
        
        return stringDate
    }
}
