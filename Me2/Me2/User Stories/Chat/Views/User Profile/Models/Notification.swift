//
//  Notification.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/1/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import SwiftyJSON

class UserNotification {
    let id: Int
    let iconURL: String
    let message: String
    let time: String
    var isNew = true
    
    init(json: JSON) {
        id = json["id"].intValue
        iconURL = ""
        message = json["message"].stringValue
        time = json["created_at"].stringValue.date(by: .reviewDate)?.date(by: .custom(format: "MMM yyyy, hh:mm")) ?? ""
    }
}
