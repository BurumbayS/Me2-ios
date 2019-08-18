//
//  PlaceDetailsCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/18/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cosmos

class PlaceDetailsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var liveChatButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var segmentedControl: CustomSegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
    }

    private func configureViews() {
        liveChatButton.tintColor = Color.blue
        liveChatButton.layer.cornerRadius = 5
        liveChatButton.layer.borderColor = Color.blue.cgColor
        liveChatButton.layer.borderWidth = 2.0
        segmentedControl.configure(for: ["Инфо","Меню","Отзывы"], with: UIScreen.main.bounds.width)
    }
}
