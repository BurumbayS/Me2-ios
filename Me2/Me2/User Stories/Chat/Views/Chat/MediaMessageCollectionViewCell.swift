//
//  MediaMessageCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/3/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography
import NVActivityIndicatorView

class MediaMessageCollectionViewCell: UICollectionViewCell {
    
    let thumbnailImageView = UIImageView()
    let timeLabel = UILabel()
    var loader: NVActivityIndicatorView!
    let imageSideConstraints = ConstraintGroup()
    
    var message: Message!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(message: Message) {
        self.message = message
        
        if message.status == .pending {
            loader.startAnimating()
        }
        
        if let media = message.file {
            if media.file != "" && media.thumbnail == nil {
                self.thumbnailImageView.kf.setImage(with: URL(string: media.file), placeholder: UIImage(named: "place_default_image"), options: [])
            } else {
                self.thumbnailImageView.image = media.thumbnail
            }
            self.timeLabel.text = message.getTime()
        }
        
        if message.isMine() {
            constrain(thumbnailImageView, self.contentView, replace: imageSideConstraints) { image, view in
                image.right == view.right - 10
            }
        } else {
            constrain(thumbnailImageView, self.contentView, replace: imageSideConstraints) { image, view in
                image.left == view.left + 10
            }
        }
    }
    
    private func setUpViews() {
        let timeView = UIView()
        timeView.layer.cornerRadius = 7
        timeView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        
        timeLabel.textColor = .white
        timeLabel.font = UIFont(name: "Roboto-Regular", size: 11)
        timeView.addSubview(timeLabel)
        constrain(timeLabel, timeView) { label, view in
            label.left == view.left + 5
            label.right == view.right - 5
            label.top == view.top
            label.bottom == view.bottom
        }
        
        thumbnailImageView.addSubview(timeView)
        constrain(timeView, thumbnailImageView) { time, image in
            time.right == image.right - 5
            time.bottom == image.bottom - 5
            time.height == 14
        }
        
        loader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .lineSpinFadeLoader, color: .lightGray, padding: 0)
        thumbnailImageView.addSubview(loader)
        constrain(loader, thumbnailImageView) { loader, image in
            loader.centerX == image.centerX
            loader.centerY == image.centerY
            loader.width == 20
            loader.height == 20
        }
        
        thumbnailImageView.backgroundColor = Color.blue
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
