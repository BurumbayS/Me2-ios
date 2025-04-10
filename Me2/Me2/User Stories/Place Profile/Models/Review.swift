//
//  Review.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/14/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import SwiftyJSON

class ReviewUser {
    let id: Int
    var username: String?
    var avatar: String?
    
    init(json: JSON) {
        id = json["id"].intValue
        username = json["full_name"].stringValue
        avatar = json["avatar"].stringValue
    }
}

class Review {
    let id: Int
    let body: String
    let rating: Double
    let user: ReviewUser
    let createdAt: Date
    var responses = [Review]()
    
    init(json: JSON) {
        id = json["id"].intValue
        body = json["body"].stringValue
        rating = json["rating"].doubleValue
        self.createdAt = json["created_at"].stringValue.date() ?? Date()
        user = ReviewUser(json: json["user"])
        
        for item in json["reviews"].arrayValue {
            responses.append(Review(json: item))
        }
    }

    var createdAtString: String? {
        if #available(iOS 13.0, *) {
            return self.createdAt.timeAgoDisplay()
        } else {
            return self.createdAt.getElapsedInterval()
        }
    }
}
