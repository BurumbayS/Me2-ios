//
//  AdressTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/28/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class AdressTableViewCell: UITableViewCell {

    let iconImageView = UIImageView()
    let adressLabel = UILabel()
    let additionalInfoLabel = UILabel()
    let distanceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with adress: String, additionalInfo: String, distance: String) {
        adressLabel.text = adress
        additionalInfoLabel.text = additionalInfo
        distanceLabel.text = distance
    }
    
    private func setUpViews() {
        iconImageView.image = UIImage(named: "location")
        self.contentView.addSubview(iconImageView)
        constrain(iconImageView, self.contentView) { icon, view in
            icon.width == 17
            icon.height == 22
            icon.left == view.left + 22
        }
        
        let view = UIView()
        
        adressLabel.textColor = Color.red
        adressLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        view.addSubview(adressLabel)
        constrain(adressLabel, view) { adress, view in
            adress.top == view.top
            adress.left == view.left
        }
        
        additionalInfoLabel.textColor = .gray
        additionalInfoLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        view.addSubview(additionalInfoLabel)
        constrain(additionalInfoLabel, adressLabel, view) { additional, adress, view in
            additional.top == adress.bottom
            additional.bottom == view.bottom
            additional.trailing == adress.trailing
            additional.leading == adress.leading
        }
        
        distanceLabel.textColor = .darkGray
        distanceLabel.textAlignment = .right
        distanceLabel.font = UIFont(name: "Roboto-Medium", size: 13)
        view.addSubview(distanceLabel)
        constrain(distanceLabel, adressLabel, view) { distance, adress, view in
            distance.left == adress.right + 10
            distance.centerY == adress.centerY
            distance.right == view.right
        }
        
        self.contentView.addSubview(view)
        constrain(view, iconImageView, self.contentView) { view, icon, contentView in
            view.left == icon.right + 15
            view.right == contentView.right - 22
            view.top == contentView.top + 20
            view.bottom == contentView.bottom - 10
            view.centerY == icon.centerY
        }
    }
}
