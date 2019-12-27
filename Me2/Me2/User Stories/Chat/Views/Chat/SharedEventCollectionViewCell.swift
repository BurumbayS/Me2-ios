//
//  SharedEventCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/28/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class SharedEventCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeLogoImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cardViewLeftConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.drawShadow(forOpacity: 0.3, forOffset: CGSize(width: 0, height: 0), radius: 3)
    }

    func configure(event: Event, senderType: SenderType) {
        eventImageView.kf.setImage(with: URL(string: event.imageURL ?? ""), placeholder: UIImage(named: "default_event_image"), options: [])
        placeLogoImageView.kf.setImage(with: URL(string: event.place.logo ?? ""), placeholder: UIImage(named: "default_place_logo"), options: [])
        titleLabel.text = event.title
        locationLabel.text = event.place.address1
        timeLabel.text = event.getTime()
        
        switch senderType {
        case .my:
            cardViewLeftConstraint.constant = UIScreen.main.bounds.width - 250 - 10
        default:
            cardViewLeftConstraint.constant = 20
        }
        
        self.contentView.layoutIfNeeded()
    }
}
