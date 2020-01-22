//
//  SharedPlaceCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/29/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cosmos

class SharedPlaceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var availabilityStatusView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardViewLeftConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.drawShadow(forOpacity: 0.3, forOffset: CGSize(width: 0, height: 0), radius: 3)
    }
    
    func configure(place: Place, senderType: SenderType) {
        nameLabel.text = place.name
        logoImageView.kf.setImage(with: URL(string: place.logo ?? ""), placeholder: UIImage(named: "default_place_logo"), options: [])
        addressLabel.text = place.address1
        categoryLabel.text = place.category
        if place.images.count > 0 {
            thumbnailImageView.kf.setImage(with: URL(string: place.images[0]), placeholder: UIImage(named: "default_place_image"), options: [])
        }
        
        if let rating = place.rating {
            let roundedRating = Double(round(rating * 10) / 10)
            ratingView.rating = roundedRating
            ratingView.text = "\(roundedRating)"
        } else {
            ratingView.isHidden = true
        }
        
        configureAvalabilityView(with: place.workingHours)
        
        switch senderType {
        case .my:
            cardViewLeftConstraint.constant = UIScreen.main.bounds.width - 250 - 10
        default:
            cardViewLeftConstraint.constant = 20
        }
        
        self.contentView.layoutIfNeeded()
    }
    
    private func configureAvalabilityView(with workingHours: WorkingHours?) {
        guard let workingHours = workingHours else { return }
        
        let today = Date().dayOfTheWeek()
        let day = workingHours.weekDays.filter { $0.title == today }[0]
        let time = Date().currentTime()
        
        if time > day.start && time < day.end {
            availabilityLabel.text = "Открыто до \(day.end)"
            availabilityStatusView.backgroundColor = Color.green
        }
        if time < day.start {
            availabilityLabel.text = "Закрыто до \(day.start)"
            availabilityStatusView.backgroundColor = Color.red
        }
        if time > day.end {
            availabilityLabel.text = "Закрыто до завтра"
            availabilityStatusView.backgroundColor = Color.red
        }
        if time > day.end && day.end == "00:00" {
            availabilityLabel.text = "Открыто до \(day.end)"
            availabilityStatusView.backgroundColor = Color.green
        }
    }
}
