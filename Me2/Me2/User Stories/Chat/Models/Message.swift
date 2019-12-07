//
//  Message.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/29/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import SwiftyJSON

enum SenderType {
    case my
    case partner
}

enum MessageType: String {
    case TEXT
    case AUDIO
    case IMAGE
    case VIDEO
    case LOCATION
    case WAVE
    case BOOKING
}

enum MessageStatus: String {
    case pending
    case sended
}

class Message {
    let maxWidth: CGFloat = 250
    let sidePaddings: CGFloat = 20
    
    let height: CGFloat
    let width: CGFloat
    
    let id: Int64
    var uuid: String!
    let text: String
    let time: String
    let sender: Int
    let type: MessageType
    var status: MessageStatus
    let createdAt: String
    let place: Place?
    let event: Event?
    var file: MediaFile?
    
    init(json: JSON, media: Data? = nil, status: MessageStatus = .sended) {
        self.id = json["id"].int64Value
        self.text = json["text"].stringValue
        self.time = "15:07"
        self.type = MessageType(rawValue: json["message_type"].stringValue) ?? .TEXT
        self.sender = json["sender"].intValue
        self.createdAt = json["created_at"].stringValue
        self.place = Place(json: json["data"]["place"])
        self.event = Event(json: json["data"]["event"])
        self.file = MediaFile(json: json["file"])
        self.uuid = json["data"]["uuid"].stringValue
        self.status = status
        
        //calculate height and width for message view width date and paddings
        self.height = ceil(text.getHeight(withConstrainedWidth: maxWidth, font: UIFont(name: "Roboto-Regular", size: 16)!)) + 10 + 15
        
        let timeTextWidth = ceil(time.getWidth(with: UIFont(name: "Roboto-Regular", size: 11)!)) + sidePaddings
        let messageTextWidth = ceil(text.getWidth(with: UIFont(name: "Roboto-Regular", size: 15)!)) + sidePaddings
        self.width = min( max(timeTextWidth, messageTextWidth) , maxWidth)
    }
    
    func isMine() -> Bool {
        if self.sender == 0 { return true }
        
        return self.sender == (UserDefaults().object(forKey: UserDefaultKeys.userID.rawValue) as? Int)
    }
    
    func getTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        let date = dateFormatter.date(from: createdAt)
        
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date ?? Date())
    }
    
    func getVideoThumbnail() {
        
    }
}
