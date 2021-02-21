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

    func date(by format: DateFormat = .reviewDateDisplay) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = format.dateFormat
        return dateFormatter.string(from: self)
    }

    func getElapsedInterval() -> String? {

        var calendar = Calendar.current
        calendar.locale = .current
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.calendar = calendar

        let interval = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute], from: self, to: Date())

        if let year = interval.year, year > 0 {
            formatter.allowedUnits = [.year] //2 years
        } else if let month = interval.month, month > 0 {
            formatter.allowedUnits = [.month] //1 month
        } else if let week = interval.weekOfYear, week > 0 {
            formatter.allowedUnits = [.weekOfMonth] //3 weeks
        } else if let day = interval.day, day > 0 {
            formatter.allowedUnits = [.day] // 6 days
        }else  if let hour = interval.hour, hour > 0 {
            formatter.allowedUnits = [.hour] // 6 days
        }else  if let hour = interval.minute, hour > 0 {
            formatter.allowedUnits = [.minute] // 6 days
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: Bundle.main.preferredLocalizations[0]) //--> IF THE USER HAVE THE PHONE IN SPANISH BUT YOUR APP ONLY SUPPORTS I.E. ENGLISH AND GERMAN WE SHOULD CHANGE THE LOCALE OF THE FORMATTER TO THE PREFERRED ONE (IS THE LOCALE THAT THE USER IS SEEING THE APP), IF NOT, THIS ELAPSED TIME IS GOING TO APPEAR IN SPANISH
            dateFormatter.dateStyle = .medium
            dateFormatter.doesRelativeDateFormatting = true

            return dateFormatter.string(from: self) // IS GOING TO SHOW 'TODAY'
        }

        return formatter.string(from: self, to: Date())?.appending(" назад")
    }

    @available(iOS 13.0, *)
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.locale = .current
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
