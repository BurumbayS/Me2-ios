//
//  NotificationTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/1/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class NotificationTableViewCell: UITableViewCell {

    let unreadMessageView = UIView()
    let iconImageView = UIImageView()
    let messageLabel = UILabel()
    let timeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(notification: UserNotification) {
        iconImageView.image = UIImage(named: "sample_place_logo")
        messageLabel.text = notification.message
        timeLabel.text = notification.time
    }
    
    private func setupViews() {
        unreadMessageView.backgroundColor = Color.red
        self.contentView.addSubview(unreadMessageView)
        constrain(unreadMessageView, self.contentView) { unreadView, view in
            unreadView.left == view.left
            unreadView.top == view.top
            unreadView.bottom == view.bottom
            unreadView.width == 5
        }
        
        iconImageView.layer.cornerRadius = 24
        self.contentView.addSubview(iconImageView)
        constrain(iconImageView, self.contentView) { icon, view in
            icon.height == 48
            icon.width == 48
            icon.left == view.left + 20
            icon.top == view.top + 20
            icon.bottom == view.bottom - 20
        }
        
        messageLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        messageLabel.numberOfLines = 0
        self.contentView.addSubview(messageLabel)
        constrain(messageLabel, iconImageView) { message, icon in
            message.left == icon.right + 15
            message.centerY == icon.centerY
        }
        
        timeLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        self.contentView.addSubview(timeLabel)
        constrain(timeLabel, messageLabel, self.contentView) { time, message, view in
            time.left == message.right + 15
            time.right == view.right - 20
            time.centerY == message.centerY
        }
    }
}
