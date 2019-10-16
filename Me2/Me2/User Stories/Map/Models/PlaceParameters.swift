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
        uuid = json["uuid"].stringValue
        usersCount = json["users_count"].intValue
        
        avatars = [String]()
        for item in json["avatars"].arrayValue {
            avatars.append(item.stringValue)
        }
    }
}
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
