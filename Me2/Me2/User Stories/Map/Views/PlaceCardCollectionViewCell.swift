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
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var livaChatButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var backView: UIView!
    
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
}
