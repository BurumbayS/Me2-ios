//
//  MediaMessageCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/3/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class MediaMessageCollectionViewCell: UICollectionViewCell {
    
    let thumbnailImageView = UIImageView()
    let timeLabel = UILabel()
    let imageSideConstraints = ConstraintGroup()
    
    var mediaType: MessageType!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(messageType: MessageType, thumbnail: String?, time: String) {
        self.mediaType = messageType
        self.thumbnailImageView.kf.setImage(with: URL(string: thumbnail ?? ""), placeholder: UIImage(named: "image_placeholder"), options: [])
        self.timeLabel.text = time
    }
    
    private func setUpViews() {
        timeLabel.textColor = .white
        timeLabel.font = UIFont(name: "Roboto-Regular", size: 11)
        timeLabel.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        thumbnailImageView.addSubview(timeLabel)
        constrain(timeLabel, thumbnailImageView) { label, image in
            label.right == image.right - 5
            label.bottom == image.bottom - 5
        }
        
        thumbnailImageView.contentMode = .scaleAspectFit
        thumbnailImageView.layer.cornerRadius = 5
        self.contentView.addSubview(thumbnailImageView)
        constrain(thumbnailImageView, self.contentView) { image, view in
            image.top == view.top
            image.bottom == view.bottom
            image.height == 200
            image.width == 200
        }
        constrain(thumbnailImageView, self.contentView, replace: imageSideConstraints) { image, view in
            image.left == view.left + 10
        }
    }
}
