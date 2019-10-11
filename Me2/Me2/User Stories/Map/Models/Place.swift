//
//  Place.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/26/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation
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
    var id: Int
    var file: String
    var menu_type: String
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.file = json["file"].stringValue
        self.menu_type = json["menu_type"].stringValue
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

class Place {
    var id: Int!
    var name: String!
    var description: String?
    var category: String?
    var regStatus: PlaceStatus!
    var rating: Double?
    var longitute: Double!
    var latitude: Double!
    var distance: Double?
    var address1: String!
    var address2: String!
    var instagram: String?
    var phone: String?
    var email: String?
    var website: String?
    var logo: String?
    var menus: [Menu]?
    var images = [String]()
    var workingHours: WorkingHours?
    var roomInfo: RoomInfo?
    
    init(json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        description = json["description"].stringValue
        latitude = json["location"]["latitude"].doubleValue
        longitute = json["location"]["longitude"].doubleValue
        address1 = json["location"]["address1"].stringValue
        address2 = json["location"]["address2"].stringValue
        regStatus = (json["reg_status"].stringValue == "REGISTERED") ? .registered : .not_registered
        rating = json["rating"].doubleValue
        logo = json["logo"].stringValue
        instagram = json["instagram"].stringValue
        email = json["email"].stringValue
        phone = json["phone"].stringValue
        website = json["website"].stringValue
        workingHours = WorkingHours(json: json["working_hours"])
        roomInfo = RoomInfo(json: json["room_info"])
        
        images = []
        for image in json["images"].arrayValue {
            images.append(image.stringValue)
        }
        
        menus = [Menu]()
        for item in json["menu"].arrayValue {
            let menu = Menu(json: item)
            menus?.append(menu)
        }
     }
}
