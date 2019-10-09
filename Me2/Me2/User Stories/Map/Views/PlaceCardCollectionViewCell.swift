//
//  PlaceCardCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/14/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cosmos

class PlaceCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var livaChatButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var availabilityStatusView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
    }
    
    private func configureViews() {
        backView.drawShadow(forOpacity: 0.3, forOffset: CGSize(width: 0, height: 0), radius: 5)
        
        livaChatButton.titleLabel?.textColor = Color.blue
        livaChatButton.layer.cornerRadius = 5
        livaChatButton.layer.borderColor = Color.blue.cgColor
        livaChatButton.layer.borderWidth = 1
    }
    
    func configure(with place: Place) {
        titleLabel.text = place.name
        logoImageView.kf.setImage(with: URL(string: place.logo ?? ""), placeholder: UIImage(named: "default_place_logo"), options: [])
        
        if let rating = place.rating {
            let roundedRating = Double(round(rating * 10) / 10)
            ratingView.rating = roundedRating
            ratingView.text = "\(roundedRating)"
        } else {
            ratingView.isHidden = true
        }
        
        configureAvalabilityView(with: place.workingHours)
        configureRoomInfo(with: place.roomInfo)
    }
    
    private func configureRoomInfo(with data: RoomInfo?) {
        guard let roomInfo = data else { return }
        
        let limit = (roomInfo.usersCount > 3) ? 3 : roomInfo.usersCount
        
        var x = 0
        for i in 0..<limit {
            let imageView = UIImageView(frame: CGRect(x: x, y: 0, width: 26, height: 26))
            imageView.kf.setImage(with: URL(string: roomInfo.avatars[i]), placeholder: nil, options: [])
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 13
            
            stackView.addSubview(imageView)
            
            x += 15
        }
        
        if roomInfo.usersCount > 3 {
            x += 15
            let label = UILabel(frame: CGRect(x: x, y: 0, width: 100, height: 26))
            label.textColor = .gray
            label.font = UIFont(name: "Roboto-Regular", size: 13)
            label.text = "+\(roomInfo.usersCount - 3)"
            
            stackView.addSubview(label)
        }
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
