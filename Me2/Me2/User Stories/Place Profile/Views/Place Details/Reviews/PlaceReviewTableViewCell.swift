//
//  PlaceReviewTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/2/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cosmos
import Cartography

class PlaceReviewTableViewCell: UITableViewCell {

    let avatarImageView = UIImageView()
    let usernameLabel = UILabel()
    let ratingView = CosmosView()
    let dateLabel = UILabel()
    let reviewLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with review: NSObject?) {
        avatarImageView.image = UIImage(named: "sample_avatar")
        usernameLabel.text = "dana.ar"
        ratingView.rating = 4.0
        dateLabel.text = "15 мин"
        reviewLabel.text = "Lorem ipsum dolor sit, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magnaaliqua. "
    }
    
    private func setUpViews() {
        avatarImageView.layer.cornerRadius = 20
        self.contentView.addSubview(avatarImageView)
        constrain(avatarImageView, self.contentView) { avatar, view in
            avatar.top == view.top + 20
            avatar.left == view.left + 20
            avatar.height == 40
            avatar.width == 40
        }
        
        usernameLabel.textColor = .black
        usernameLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        self.contentView.addSubview(usernameLabel)
        constrain(usernameLabel, avatarImageView) { username, avatar in
            username.top == avatar.top
            username.left == avatar.right + 10
        }
        
        ratingView.settings.totalStars = 5
        ratingView.settings.starSize = 12
        ratingView.settings.starMargin = 4
        self.contentView.addSubview(ratingView)
        constrain(ratingView, usernameLabel, avatarImageView) { rating, username, avatar in
            rating.leading == username.leading
            rating.bottom == avatar.bottom
            rating.width == 75
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
