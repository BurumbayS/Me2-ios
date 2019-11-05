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
//    let companion: 
    
    init(json: JSON) {
        uuid = json["uuid"].stringValue
        type = RoomType(rawValue: json["room_type"].stringValue) ?? RoomType.SIMPLE
        lastMessage = Message(json: json["last_message"])
    }
}
