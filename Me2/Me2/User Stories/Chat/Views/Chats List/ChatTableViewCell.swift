//
//  ChatTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/3/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var liveChatContextView: UIView!
    @IBOutlet weak var simpleChatContextView: UIView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var liveChatLastMessage: UILabel!
    @IBOutlet weak var simpleChatNameLabel: UILabel!
    @IBOutlet weak var simpleChatLastMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configure(with roomInfo: Room) {
        switch roomInfo.type {
        case .SIMPLE:
            
            simpleChatNameLabel.text = roomInfo.name
            simpleChatLastMessage.text = roomInfo.lastMessage.text
            
            simpleChatContextView.isHidden = false
            liveChatContextView.isHidden = true
        
        case .LIVE:
            
            placeNameLabel.text = roomInfo.name
            let lastMessageSenderName = roomInfo.getLastMessageSender().username
            liveChatLastMessage.text = "\(lastMessageSenderName): \(roomInfo.lastMessage.text)"
            
            simpleChatContextView.isHidden = true
            liveChatContextView.isHidden = false
            
        default:
            break
        }
        
        avatarImageView.kf.setImage(with: URL(string: roomInfo.avatarURL), placeholder: UIImage(named: "placeholder_avatar"), options: [])
        dateTimeLabel.text = roomInfo.lastMessage.getTime()
    }
}
