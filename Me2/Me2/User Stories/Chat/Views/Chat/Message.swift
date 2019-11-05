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
    let height: CGFloat
    let width: CGFloat
    
    let id: Int64
    let text: String
    let time: String
    let sender: Int
    let type: MessageType
    
    init(json: JSON) {
        self.id = json["id"].int64Value
        self.text = json["text"].stringValue
        self.time = "15:07"
        self.type = MessageType(rawValue: json["message_type"].stringValue)!
        self.sender = json["sender"].intValue
        
        //calculate height and width for message view width date and paddings
        self.height = text.getHeight(withConstrainedWidth: maxWidth, font: UIFont(name: "Roboto-Regular", size: 15)!) + 10 + 15
        self.width = min(ceil(text.getWidth(with: UIFont(name: "Roboto-Regular", size: 15)!)) + 20, maxWidth)
    }
    
    func isMine() -> Bool {
        return true
    }
}
