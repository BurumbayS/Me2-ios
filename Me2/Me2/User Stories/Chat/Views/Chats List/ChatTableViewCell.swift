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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configure(with roomInfo: Room) {
        switch roomInfo.type {
        case .SIMPLE:
            
            avatarImageView.kf.setImage(with: URL(string: roomInfo.participants[0].avatar), placeholder: UIImage(named: "sample_avatar"), options: [])
            nameLabel.text = roomInfo.participants[0].username
            lastMessageLabel.text = roomInfo.lastMessage.text
        
        case .LIVE:
            
            nameLabel.text = "LIVE"
            lastMessageLabel.text = roomInfo.lastMessage.text
            
        default:
            break
        }
    }
}
