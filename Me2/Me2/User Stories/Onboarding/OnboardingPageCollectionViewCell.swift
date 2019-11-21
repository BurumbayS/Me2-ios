//
//  OnboardingPageCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/21/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

struct OnboardingModel {
    let title: String
    let text: String
    let illustration: String
}

class OnboardingPageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var illustrationImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(model: OnboardingModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.text
        illustrationImageView.image = UIImage(named: model.illustration)
    }

}
