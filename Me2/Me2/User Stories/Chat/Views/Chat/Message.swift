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
    case FILE
}

class Message {
    let maxWidth: CGFloat = 250
    let sidePaddings: CGFloat = 20
    
    let height: CGFloat
    let width: CGFloat
    
    let id: Int64
    let text: String
    let time: String
    let sender: Int
    let type: MessageType
    let createdAt: String
    
    init(json: JSON) {
        self.id = json["id"].int64Value
        self.text = json["text"].stringValue
        self.time = "15:07"
        self.type = MessageType(rawValue: json["message_type"].stringValue) ?? .TEXT
        self.sender = json["sender"].intValue
        self.createdAt = json["created_at"].stringValue
        
        //calculate height and width for message view width date and paddings
        self.height = text.getHeight(withConstrainedWidth: maxWidth, font: UIFont(name: "Roboto-Regular", size: 15)!) + 10 + 15
        
        let timeTextWidth = ceil(time.getWidth(with: UIFont(name: "Roboto-Regular", size: 11)!)) + sidePaddings
        let messageTextWidth = ceil(text.getWidth(with: UIFont(name: "Roboto-Regular", size: 15)!)) + sidePaddings
        self.width = min( max(timeTextWidth, messageTextWidth) , maxWidth)
    }
    
    func isMine() -> Bool {
        if self.sender == 0 { return true }
        
        return self.sender == (UserDefaults().object(forKey: UserDefaultKeys.userID.rawValue) as? Int)
    }
}
