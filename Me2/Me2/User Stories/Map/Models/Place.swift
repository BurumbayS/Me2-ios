//
//  Place.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/26/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation
import SwiftyJSON

class Place {
    var id: Int!
    var name: String!
    var description: String?
    var category: String!
    var regStatus: PlaceStatus!
    var isFavourite: Bool
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
    var roomInfo: RoomInfo
    var tags = [String]()
    var branch: Int
    var subsidiaries: [Place]?
    
    init?(json: JSON) {
        
        guard let roomInfo = RoomInfo(json: json["room_info"]) else {
            return nil
        }
        id = json["id"].intValue
        name = json["name"].stringValue
        category = json["place_type"]["name"].stringValue
        isFavourite = json["is_favourite"].boolValue
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
        self.roomInfo = roomInfo
        branch = json["branch"].intValue
        
        images = []
        for image in json["images"].arrayValue {
            images.append(image.stringValue)
        }
        
        menus = [Menu]()
        for item in json["menu"].arrayValue {
            let menu = Menu(json: item)
            menus?.append(menu)
        }
        
        tags = []
        for item in json["tags_display"].arrayValue {
            tags.append(item.stringValue)
        }
    }
    
    func generateShareInfo() -> String {
        var message = ""
        
        message =   "\(name!)\n" +
                    "\(address1!)\n" +
                    "\(instagram!)" +
                    "\n" +
                    "\n" +
                    "Для просмотра подробной информации откройте в приложении Me2" +
                    "\n" +
                    "\n" +
                    "Доступно бесплатно в:\n" +
                    "App store: www.me2.kz\n" +
                    "Google play: www.me2.kz"
        
        return message
    }
}
