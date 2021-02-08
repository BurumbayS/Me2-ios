//
//  PlaceParameters.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/15/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import SwiftyJSON

enum PlaceStatus {
    case registered
    case not_registered
    
    var pages: [PlaceProfilePage] {
        switch self {
        case .registered:
            return [PlaceProfilePage.info, .events, .menu, .reviews]
        case .not_registered:
            return [PlaceProfilePage.info, .reviews]
        }
    }
    
    var pagesTitles: [String] {
        switch self {
        case .registered:
            return ["Инфо","События","Меню","Отзывы"]
        case .not_registered:
            return ["Инфо", "Отзывы"]
        }
    }
}

struct Menu {
    enum MenuType: String {
        case main = "MAIN"
        case bar = "BAR"
        case additional = "EXTRA"
        
        var title: String {
            switch self {
            case .main:
                return "Основное меню"
            case .bar:
                return "Барное меню"
            case .additional:
                return "Дополнительное меню"
            }
        }
        
        var image: UIImage {
            switch self {
            case .main:
                return UIImage(named: "main_menu_icon")!
            case .bar:
                return UIImage(named: "bar_menu_icon")!
            case .additional:
                return UIImage(named: "main_menu_icon")!
            }
        }
    }
    
    var id: Int
    var file: String
    var menu_type: MenuType
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.file = json["file"].stringValue
        
        self.menu_type = MenuType(rawValue: json["menu_type"].stringValue) ?? MenuType.main
    }
}

struct RoomInfo {
    var uuid: String
    var usersCount: Int
    var avatars: [String]
    
    init(json: JSON) {
        print(json.description)
        uuid = json["uuid"].stringValue
        usersCount = json["users_count"].intValue
        
        avatars = [String]()
        for item in json["avatars"].arrayValue {
            avatars.append(item.stringValue)
        }
    }
}

enum WeekDayName: String {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var localShortTitle: String {
        switch self {
        case .sunday:
            return "Вс"
        case .monday:
            return "Пн"
        case .tuesday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Сб"
        }
    }
}

struct WeekDay {
    var name: WeekDayName
    var title: String
    var start: String
    var end: String
    var works: Bool
    
    var isWeekend: Bool {
        switch name {
        case .sunday, .saturday:
            return true
        default:
            return false
        }
    }
    
    func isEgual(to weekDay: WeekDay) -> Bool {
        if self.start == weekDay.start && self.end == weekDay.end {
            return true
        }
        
        return false
    }
}

class WorkingHours {
    var weekDays = [WeekDay]()
    
    init(json: JSON) {
        for item in json.dictionaryValue {
            let title = item.key
            let name = WeekDayName(rawValue: title)!
            let start = item.value["start"].stringValue
            let end = item.value["end"].stringValue
            let works = item.value["works"].boolValue
            
            weekDays.append(WeekDay(name: name, title: title, start: start, end: end, works: works))
        }
    }
}
