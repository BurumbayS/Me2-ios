//
//  ChatParticipant.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/5/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import SwiftyJSON

class ChatParticipant {
    var id: Int
    var avatar: String
    var fullName: String
    var username: String
    
    init(json: JSON) {
        id = json["id"].intValue
        avatar = json["avatar"].stringValue
        fullName = json["full_name"].stringValue
        username = json["username"].stringValue
    }
}
