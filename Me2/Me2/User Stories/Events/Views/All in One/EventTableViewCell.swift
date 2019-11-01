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
    
    @IBOutlet weak var flagButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeLogoImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var event: Event!
    
    private func configureViews() {
        layoutIfNeeded()
        
        eventTypeView.roundCorners([.topRight, .bottomRight], radius: 15, size: CGRect(x: 0, y: 0, width: eventTypeView.frame.width, height: eventTypeView.frame.height))
        
        backView.layer.cornerRadius = 5
        
        self.drawShadow(color: UIColor.black.cgColor, forOpacity: 0.3, forOffset: CGSize(width: 0, height: 0), radius: 5)
        self.backgroundColor = .clear
    }
    
    func configure(wtih event: Event) {
        self.event = event
        
        placeLogoImageView.kf.setImage(with: URL(string: event.place.logo ?? ""), placeholder: UIImage(named: "default_place_logo"), options: [])
        eventImageView.kf.setImage(with: URL(string: event.imageURL ?? ""), placeholder: UIImage(named: "default_place_logo"), options: [])
        flagButton.setBackgroundImage(event.flagImage, for: .normal)
        eventTypeLabel.text = event.eventType
        titleLabel.text = event.title
        locationLabel.text = event.place.name
        timeLabel.text = event.getTime()
        
        configureViews()
        bindDynamics()
    }
    
    private func bindDynamics() {
        event.isFavourite.bind { [unowned self] (status) in
            self.updateFlag()
        }
    }
    
    @IBAction func flagButtonPressed(_ sender: Any) {
        event.isFavourite.value = !event.isFavourite.value
        
        event.changeFavouriteStatus { [weak self] (status, message) in
            switch status {
            case .ok:
                break
            default:
                self?.event.isFavourite.value = !(self?.event.isFavourite.value)!
            }
        }
    }
    
    private func updateFlag() {
        flagButton.setBackgroundImage(event.flagImage, for: .normal)
    }
}
