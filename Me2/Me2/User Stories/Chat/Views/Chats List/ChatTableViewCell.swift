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
        case .SIMPLE, .SERVICE:
            
            simpleChatNameLabel.text = (roomInfo.type == .SIMPLE) ? roomInfo.name : roomInfo.place?.name ?? ""
            simpleChatLastMessage.text = getLastMessageString(from: roomInfo.lastMessage)
            
            simpleChatContextView.isHidden = false
            liveChatContextView.isHidden = true
            
        case .LIVE:
            
            placeNameLabel.text = roomInfo.name
            
            if let lastMessageSender = roomInfo.getLastMessageSender() {
                let lastMessage = getLastMessageString(from: roomInfo.lastMessage)
                liveChatLastMessage.text = "\(lastMessageSender.username): \(lastMessage)"
            }
            
            simpleChatContextView.isHidden = true
            liveChatContextView.isHidden = false
            
        default:
            break
        }
        
        avatarImageView.kf.setImage(with: URL(string: roomInfo.avatarURL), placeholder: UIImage(named: "placeholder_avatar"), options: [])
        dateTimeLabel.text = roomInfo.lastMessage.getTime()
    }
    
    private func getLastMessageString(from message: Message) -> String {
        if let place = message.place, place.id != 0 {
            return "Заведение"
        }
        
        if let event = message.event, event.id != 0 {
            return "Событие"
        }
        
        switch message.type {
        case .TEXT:
            
            return message.text
            
        case .IMAGE:
            
            return "Фото"
            
        case .VIDEO:
            
            return "Видео"
            
        case .WAVE:
            
            return "Помахали"
            
        default:
            return ""
        }
    }
}
