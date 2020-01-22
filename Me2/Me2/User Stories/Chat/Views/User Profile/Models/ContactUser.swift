//
//  ContactUser.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/29/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import SwiftyJSON

class ContactUser {
    let id: Int
    let fullName: String?
    let username: String
    let phone: String?
    let avatar: String?
    
    init(json: JSON) {
        id = json["id"].intValue
        fullName = json["full_name"].stringValue
        username = json["username"].stringValue
        phone = json["phone"].stringValue
        avatar = json["avatar"].stringValue
    }
}
