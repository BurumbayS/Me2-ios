//
//  Contact.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/28/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import SwiftyJSON

class Contact {
    let id: Int
    let blocked: Bool
    var user2: ContactUser
    
    init(json: JSON) {
        id = json["id"].intValue
        blocked = json["blocked"].boolValue
        user2 = ContactUser(json: json["user2"])
    }
}
