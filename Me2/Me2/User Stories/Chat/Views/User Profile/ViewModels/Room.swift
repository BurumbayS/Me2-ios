//
//  Room.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/4/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import SwiftyJSON

enum RoomType: String {
    case SIMPLE
    case GROUP
    case LIVE
}

class Room {
    let uuid: String
    let type: RoomType
    let lastMessage: Message
    var participants = [ChatParticipant]()
    
    init(json: JSON) {
        uuid = json["uuid"].stringValue
        type = RoomType(rawValue: json["room_type"].stringValue) ?? RoomType.SIMPLE
        lastMessage = Message(json: json["last_message"])
        
        for item in json["participants"].arrayValue {
            guard item["id"].intValue != UserDefaults().object(forKey: UserDefaultKeys.userID.rawValue) as! Int else { continue }
            
            participants.append(ChatParticipant(json: item))
        }
    }
}
