//
//  User.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/15/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import SwiftyJSON

class User {
    let id: Int
    let username: String
    var fullName: String?
    var phone: String?
    var email: String?
    var bio: String?
    var birthDate: Date?
    var gender: String?
    var favouritePlaces = [Place]()
    var favouriteEvents = [Event]()
    
    init(json: JSON) {
        id = json["id"].intValue
        username = json["username"].stringValue
        fullName = json["full_name"].stringValue
        phone = json["phone"].stringValue
        email = json["email"].stringValue
        gender = json["gender"].stringValue
        bio = json["bio"].stringValue
    }
}
