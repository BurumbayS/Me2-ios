//
//  EventCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/24/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var flagButton: UIButton!
    @IBOutlet weak var eventTypeView: UIView!
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeLogoImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    
    var event: Event!
    
    private func configureViews() {
        layoutIfNeeded()
        
        eventTypeView.roundCorners([.topRight, .bottomRight], radius: 15, size: CGRect(x: 0, y: 0, width: eventTypeView.frame.width, height: eventTypeView.frame.height))
        
        placeLogoImageView.contentMode = .scaleAspectFill
        
        backView.layer.cornerRadius = 5
        
        self.drawShadow(color: UIColor.black.cgColor, forOpacity: 0.3, forOffset: CGSize(width: 0, height: 0), radius: 5)
        self.backgroundColor = .clear
    }

    func configure(wtih event: Event) {
        self.event = event
        
        placeLogoImageView.kf.setImage(with: URL(string: event.place.logo ?? ""), placeholder: UIImage(named: "default_place_logo"), options: [])
        imageView.kf.setImage(with: URL(string: event.imageURL ?? ""), placeholder: UIImage(named: "default_place_logo"), options: [])
        flagButton.setBackgroundImage(event.flagImage, for: .normal)
        eventTypeLabel.text = event.eventType
        titleLabel.text = event.title
        locationLabel.text = event.place.name
        timeLabel.text = event.getTime()
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hello)))
        
        configureViews()
        bindDynamics()
    }
    
    @objc func hello() {
        print("pressed")
    }
    
    private func bindDynamics() {
        event.isFavourite.bind { [weak self] (status) in
            self?.updateFlag()
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
