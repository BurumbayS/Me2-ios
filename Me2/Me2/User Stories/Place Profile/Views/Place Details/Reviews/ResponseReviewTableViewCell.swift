//
//  ResponseReviewTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/14/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class ResponseReviewTableViewCell: UITableViewCell {

    let avatarImageView = UIImageView()
    let usernameLabel = UILabel()
    let dateLabel = UILabel()
    let reviewLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with review: Review) {
        avatarImageView.kf.setImage(with: URL(string: review.user.avatar ?? ""), placeholder: UIImage(named: "sample_avatar"), options: [])//image = UIImage(named: "sample_avatar")
        usernameLabel.text = review.user.username ?? ""
        dateLabel.text = "15 мин"
        reviewLabel.text = review.body
    }
    
    private func setUpViews() {
        let replyIcon = UIImageView(image: UIImage(named: "reply_icon"))
        self.contentView.addSubview(replyIcon)
        constrain(replyIcon, self.contentView) { icon, view in
            icon.left == view.left + 40
            icon.width == 10
            icon.height == 14
        }
        
        avatarImageView.layer.cornerRadius = 20
        self.contentView.addSubview(avatarImageView)
        constrain(avatarImageView, replyIcon, self.contentView) { avatar, replyIcon, view in
            avatar.top == view.top + 20
            avatar.left == replyIcon.right + 10
            avatar.height == 40
            avatar.width == 40
            replyIcon.centerY == avatar.centerY
        }
        
        usernameLabel.textColor = .black
        usernameLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        self.contentView.addSubview(usernameLabel)
        constrain(usernameLabel, avatarImageView) { username, avatar in
            username.centerY == avatar.centerY
            username.left == avatar.right + 10
        }
        
        dateLabel.textColor = .darkGray
        dateLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        self.contentView.addSubview(dateLabel)
        constrain(dateLabel, usernameLabel, self.contentView) { date, username, view in
            date.right == view.right - 20
            date.top == username.top
        }
        
        reviewLabel.textColor = .darkGray
        reviewLabel.numberOfLines = 0
        reviewLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        self.contentView.addSubview(reviewLabel)
        constrain(reviewLabel, avatarImageView, self.contentView) { review, avatar, view in
            review.top == avatar.bottom + 10
            review.leading == avatar.leading
            review.bottom == view.bottom - 20
            review.right == view.right - 20
        }
    }

}
