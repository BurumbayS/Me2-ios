//
//  LiveChatMessageCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/7/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class LiveChatMessageCollectionViewCell: UICollectionViewCell {
    let avatarImageView = UIImageView()
    let usernameLabel = UILabel()
    let messageLabel = UILabel()
    let dateLabel = UILabel()
    let textBubbleView = UIView()
    
    let bubbleViewConstraints = ConstraintGroup()
    
    static let minimalCellWidth: CGFloat = 80
    static let minimalCellHeight: CGFloat = 50
    static let usernameLabelHeight: CGFloat = 15
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with message: Message, and sender: ChatParticipant?) {
        avatarImageView.kf.setImage(with: URL(string: sender?.avatar ?? ""), placeholder: UIImage(named: "placeholder_avatar"), options: [])
        usernameLabel.text = sender?.username
        messageLabel.text = message.text
        
        configureBubbleView(with: message, and: sender)
    }
    
    private func configureBubbleView(with message: Message, and sender: ChatParticipant?) {
        let senderUsernameWidth = ceil(sender?.username.getWidth(with: UIFont(name: "Roboto-Regular", size: 13)!) ?? 0) + 20
        constrain(textBubbleView, self.contentView, replace: bubbleViewConstraints) { bubbleView, view in
            bubbleView.width == max(message.width, senderUsernameWidth)
        }
        self.textBubbleView.roundCorners([.topLeft, .topRight, .bottomRight], radius: 10, size: CGRect(x: 0, y: 0, width: max(message.width, senderUsernameWidth), height: message.height + LiveChatMessageCollectionViewCell.usernameLabelHeight))
    }
    
    private func setupViews() {
        self.backgroundColor = .clear
        
        usernameLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        usernameLabel.textColor = Color.blue
        textBubbleView.addSubview(usernameLabel)
        constrain(usernameLabel, textBubbleView) { username, view in
            username.left == view.left + 10
            username.top == view.top + 5
            username.height == 15
        }
        
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        textBubbleView.addSubview(messageLabel)
        constrain(messageLabel, usernameLabel, self.textBubbleView) { message, username, view in
            message.top == username.bottom + 1
            message.left == view.left + 10
            message.right == view.right - 10
        }
        
        dateLabel.font = UIFont(name: "Roboto-Regular", size: 11)
        dateLabel.textColor = .black
        dateLabel.alpha = 0.5
        dateLabel.text = "15:07"
        textBubbleView.addSubview(dateLabel)
        constrain(dateLabel, messageLabel, textBubbleView) { date, message, view in
            date.top == message.bottom
            date.right == view.right - 5
            date.bottom == view.bottom - 5
            date.height == 15
        }
        
        avatarImageView.layer.cornerRadius = 15
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        self.contentView.addSubview(avatarImageView)
        constrain(avatarImageView, self.contentView) { avatar, view in
            avatar.left == view.left + 10
            avatar.bottom == view.bottom
            avatar.height == 30
            avatar.width == 30
        }
        
        textBubbleView.backgroundColor = Color.gray
        self.contentView.addSubview(textBubbleView)
        constrain(textBubbleView, avatarImageView, self.contentView) { bubbleView, avatar, view in
            bubbleView.top == view.top
            bubbleView.bottom == view.bottom
            bubbleView.left == avatar.right + 10
        }
        constrain(textBubbleView, self.contentView, replace: bubbleViewConstraints) { bubbleView, view in
            bubbleView.width == 250
        }
    }
}
