//
//  EventDetailHeaderTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/26/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography
import Kingfisher

class EventDetailHeaderTableViewCell: UITableViewCell {

    let eventImageView = UIImageView()
    let eventTypeView = UIView()
    let eventTypeLabel = UILabel()
    let followButton = UIButton()
    
    var parentVC: UIViewController!
    var event: Event!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with event: Event, on vc: UIViewController) {
        self.parentVC = vc
        self.event = event
        
        eventTypeLabel.text = event.eventType
        followButton.setImage(event.flagImage, for: .normal)
        eventImageView.kf.setImage(with: URL(string: event.imageURL ?? ""), placeholder: UIImage(named: "placeholder_image"), options: [])
        
        layoutIfNeeded()
        eventTypeView.roundCorners([.topRight, .bottomRight], radius: 15, size: CGRect(x: 0, y: 0, width: eventTypeView.frame.width, height: eventTypeView.frame.height))
        
        bindDynamics()
    }
    
    private func setUpViews() {
        eventImageView.contentMode = .scaleAspectFill
        self.contentView.addSubview(eventImageView)
        constrain(eventImageView, self.contentView) { image, view in
            image.left == view.left
            image.top == view.top
            image.right == view.right
            image.bottom == view.bottom
            image.height == 250
        }
        
        eventTypeView.backgroundColor = Color.red
        
        eventTypeLabel.textColor = .white
        eventTypeLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        eventTypeView.addSubview(eventTypeLabel)
        constrain(eventTypeLabel, eventTypeView) { label, view in
            label.top == view.top + 5
            label.bottom == view.bottom - 5
            label.left == view.left + 10
            label.right == view.right - 10
        }
        
        self.contentView.addSubview(eventTypeView)
        constrain(eventTypeView, self.contentView) { view, superView in
            view.left == superView.left
            view.top == superView.top + 50
        }
        
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "x_icon"), for: .normal)
        closeButton.backgroundColor = .white
        closeButton.layer.cornerRadius = 19
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        self.contentView.addSubview(closeButton)
        constrain(closeButton, eventTypeView, self.contentView) { btn, eventTypeView, view in
            btn.right == view.right - 15
            btn.centerY == eventTypeView.centerY
            btn.height == 38
            btn.width == 38
        }
        
        followButton.imageEdgeInsets = UIEdgeInsets(top: 9, left: 12, bottom: 9, right: 12)
        followButton.backgroundColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 0.9)
        followButton.layer.cornerRadius = 19
        followButton.addTarget(self, action: #selector(followEvent), for: .touchUpInside)
        self.contentView.addSubview(followButton)
        constrain(followButton, closeButton) { followBtn, closeBtn in
            followBtn.right == closeBtn.left - 12
            followBtn.centerY == closeBtn.centerY
            followBtn.height == 38
            followBtn.width == 38
        }
        
        let shareButton = UIButton()
        shareButton.setImage(UIImage(named: "share_icon"), for: .normal)
        shareButton.backgroundColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 0.9)
        shareButton.layer.cornerRadius = 19
        shareButton.addTarget(self, action: #selector(shareEvent), for: .touchUpInside)
        self.contentView.addSubview(shareButton)
        constrain(shareButton, followButton) { shareBtn, followBtn in
            shareBtn.right == followBtn.left - 12
            shareBtn.centerY == followBtn.centerY
            shareBtn.height == 38
            shareBtn.width == 38
        }
    }
    
    @objc private func shareEvent() {
        
    }
    
    @objc private func close() {
        parentVC.dismiss(animated: true, completion: nil)
    }
    
    @objc private func followEvent() {
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
    
    private func bindDynamics() {
        event.isFavourite.bind { [unowned self] (status) in
            self.followButton.setImage(self.event.flagImage, for: .normal)
        }
    }
}
