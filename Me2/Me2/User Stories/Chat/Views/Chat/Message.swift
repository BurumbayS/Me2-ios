//
//  Message.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/29/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

enum MessageType {
    case my
    case partner
}

class Message {
    let maxWidth: CGFloat = 250
    
    let text: String
    let time: String
    let type: MessageType
    
    let height: CGFloat
    let width: CGFloat
    
    init(text: String, time: String, type: MessageType) {
        self.text = text
        self.time = time
        self.type = type
        
        //calculate height and width for message view width date and paddings
        self.height = text.getHeight(withConstrainedWidth: maxWidth, font: UIFont(name: "Roboto-Regular", size: 15)!) + 10 + 15
        self.width = min(ceil(text.getWidth(with: UIFont(name: "Roboto-Regular", size: 15)!)) + 20, maxWidth)
    }
}
