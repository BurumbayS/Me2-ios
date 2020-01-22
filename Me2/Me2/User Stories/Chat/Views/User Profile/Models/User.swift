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
    var firstName: String?
    var lastName: String?
    var avatar: String?
    var instagram: String?
    var phone: String?
    var email: String?
    var bio: String?
    var birthDate: String?
    var gender: String?
    var blocked: Bool
    var contact: Contact?
    var hasPassword: Bool
    var favouritePlaces = [Place]()
    var favouriteEvents = [Event]()
    var interests = [String]()
    
    init(json: JSON) {
        id = json["id"].intValue
        username = json["username"].stringValue
        fullName = json["full_name"].stringValue
        firstName = json["first_name"].stringValue
        lastName = json["last_name"].stringValue
        avatar = json["avatar"].stringValue
        instagram = json["instagram"].stringValue
        phone = json["phone"].stringValue
        email = json["email"].stringValue
        gender = json["gender"].stringValue
        bio = json["bio"].stringValue
        contact = Contact(json: json["contact"])
        blocked = json["blocked"].boolValue
        hasPassword = json["has_password"].boolValue
        birthDate = convertBirthDate(from: json["birth_date"].stringValue)
        
        json["favourite_places"].arrayValue.forEach({ favouritePlaces.append(Place(json: $0)) })
        json["interests"].arrayValue.forEach({ interests.append($0.stringValue) })
    }
    
    private func convertBirthDate(from dateString: String?) -> String {
        guard dateString != nil else { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: dateString!) {
            formatter.dateStyle = .long
            formatter.locale = Locale(identifier: "ru")
            return formatter.string(from: date)
        }
        
        return ""
    }
}
