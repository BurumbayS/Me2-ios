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
    
    func configure(with data: Int) {
        let limit = (data > 3) ? 3 : data
        var x = 0
        for _ in 0..<limit {
            let imageView = UIImageView(frame: CGRect(x: x, y: 0, width: 26, height: 26))
            imageView.layer.cornerRadius = 13
            imageView.image = UIImage(named: "sample_place_logo")
            
            stackView.addSubview(imageView)
            
            x += 15
        }
        
        if data > 3 {
            x += 15
            let label = UILabel(frame: CGRect(x: x, y: 0, width: 100, height: 26))
            label.textColor = .gray
            label.font = UIFont(name: "Roboto-Regular", size: 13)
            label.text = "+\(data - 3)"
            
            stackView.addSubview(label)
        }
    }
}
