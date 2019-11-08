//
//  ChatMessageCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/29/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class ChatMessageCollectionViewCell: UICollectionViewCell {
    
    let messageLabel = UILabel()
    let dateLabel = UILabel()
    let textBubbleView = UIView()
    
    let bubbleViewConstraints = ConstraintGroup()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(message: Message) {
        switch message.isMine() {
        case true:
            
            constrain(textBubbleView, self.contentView, replace: bubbleViewConstraints) { bubbleView, view in
                bubbleView.right == view.right - 10
                bubbleView.width == message.width
            }

            self.textBubbleView.roundCorners([.topLeft, .topRight, .bottomLeft], radius: 10, size: CGRect(x: 0, y: 0, width: message.width, height: message.height))
            self.textBubbleView.backgroundColor = Color.blue
            self.dateLabel.textColor = .white
            self.dateLabel.alpha = 0.5
            self.messageLabel.textColor = .white

        case false:
            
            constrain(textBubbleView, self.contentView, replace: bubbleViewConstraints) { bubbleView, view in
                bubbleView.left == view.left + 10
                bubbleView.width == message.width
            }

            self.textBubbleView.roundCorners([.topLeft, .topRight, .bottomRight], radius: 10, size: CGRect(x: 0, y: 0, width: message.width, height: message.height))
            self.textBubbleView.backgroundColor = Color.gray
            self.dateLabel.textColor = .black
            self.dateLabel.alpha = 0.5
            self.messageLabel.textColor = .black

        }
        
        messageLabel.text = message.text
        dateLabel.text = message.getTime()
    }
    
    private func setUpViews() {
        self.backgroundColor = .clear
        
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        textBubbleView.addSubview(messageLabel)
        constrain(messageLabel, self.textBubbleView) { message, view in
            message.top == view.top + 5
            message.left == view.left + 10
            message.right == view.right - 10
        }
        
        dateLabel.font = UIFont(name: "Roboto-Regular", size: 11)
        dateLabel.text = "15:07"
        textBubbleView.addSubview(dateLabel)
        constrain(dateLabel, messageLabel, textBubbleView) { date, message, view in
            date.top == message.bottom
            date.right == view.right - 5
            date.bottom == view.bottom - 5
            date.height == 15
        }
        
        self.contentView.addSubview(textBubbleView)
        constrain(textBubbleView, self.contentView) { bubbleView, view in
            bubbleView.top == view.top
            bubbleView.bottom == view.bottom
        }
        constrain(textBubbleView, self.contentView, replace: bubbleViewConstraints) { bubbleView, view in
            bubbleView.left == view.left + 10
            bubbleView.right == view.right - 10
        }
    }
}
