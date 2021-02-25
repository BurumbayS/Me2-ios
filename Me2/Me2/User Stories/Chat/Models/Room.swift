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
    case SERVICE
}

class Room {
    let uuid: String
    let type: RoomType
    let name: String
    let avatarURL: String
    let lastMessage: Message
    let place: Place?
    var participants = [ChatParticipant]()
    
    init(json: JSON) {
        uuid = json["uuid"].stringValue
        type = RoomType(rawValue: json["room_type"].stringValue) ?? RoomType.SIMPLE
        name = json["name"].stringValue
        avatarURL = json["avatar"].stringValue
        lastMessage = Message(json: json["last_message"])
        place = Place(json: json["place"])
        
        for item in json["participants"].arrayValue {
            participants.append(ChatParticipant(json: item))
        }
    }
    
    func getSender(of message: Message) -> ChatParticipant? {
        return participants.first(where: { $0.id == message.sender })
    }
    
    func getSecondParticipant() -> ChatParticipant {
        let participants = self.participants.filter({ $0.id != UserDefaults().object(forKey: UserDefaultKeys.userID.rawValue) as? Int })
        
        return participants[0]
    }
    
    func getLastMessageSender() -> ChatParticipant? {
        let participants = self.participants.filter({ $0.id != lastMessage.sender })
        
        if participants.count > 0 { return participants[0] } else { return nil }
    }
}
