//
//  FavouritePlaceCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/2/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class FavouritePlaceCollectionViewCell: UICollectionViewCell {
    
    let logoImageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with logo: UIImage, and title: String) {
        logoImageView.image = logo
        titleLabel.text = title
    }
    
    private func setUpViews() {
        logoImageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(logoImageView)
        constrain(logoImageView, self.contentView) { logo, view in
            logo.centerX == view.centerX
            logo.height == 50
            logo.width == 50
        }
        
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Roboto-Medium", size: 13)
        self.contentView.addSubview(titleLabel)
        constrain(titleLabel, logoImageView, self.contentView) { label, logo, view in
            label.left == view.left
            label.right == view.right
            label.bottom == view.bottom
            label.top == logo.bottom + 10
        }
    }
}
