//
//  ChatParticipant.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/5/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import SwiftyJSON

class ChatParticipant {
    let id: Int
    let avatar: String
    let fullName: String
    let username: String
    
    init(json: JSON) {
        id = json["id"].intValue
        avatar = json["avatar"].stringValue
        fullName = json["full_name"].stringValue
        username = json["username"].stringValue
    }
}
