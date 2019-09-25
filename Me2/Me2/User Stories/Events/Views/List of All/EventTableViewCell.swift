//
//  EventTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/24/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTypeView: UIView!
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeLogoImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
    }
    
    private func configureViews() {
        eventTypeView.roundCorners([.topRight, .bottomRight], radius: 15, size: CGRect(x: 0, y: 0, width: eventTypeView.frame.width, height: eventTypeView.frame.height))
        
        backView.layer.cornerRadius = 5
        
        self.drawShadow(color: UIColor.black.cgColor, forOpacity: 0.3, forOffset: CGSize(width: 0, height: 0), radius: 5)
        self.backgroundColor = .clear
    }
    
    func configure(wtih event: Event) {
        placeLogoImageView.image = UIImage(named: "sample_place_logo")
        eventImageView.image = UIImage(named: "sample_place_image")
        eventTypeLabel.text = event.eventType
        titleLabel.text = event.title
        locationLabel.text = event.location
        timeLabel.text = event.time
    }
}
