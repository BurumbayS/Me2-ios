//
//  EventPlaceTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/26/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Cartography
import UIKit

class EventPlaceTableViewCell: UITableViewCell {

    let logoImageView = UIImageView()
    let nameLabel = UILabel()
    let typeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        logoImageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(logoImageView)
        constrain(logoImageView, self.contentView) { logo, view in
            logo.top == view.top + 10
            logo.bottom == view.bottom - 10
            logo.left == view.left + 20
            logo.height == 50
            logo.width == 50
        }
        
        let view = UIView()
        view.backgroundColor = .white
        
        nameLabel.textColor = Color.red
        nameLabel.font = UIFont(name: "Roboto-Medium", size: 17)
        view.addSubview(nameLabel)
        constrain(nameLabel, view) { label, view in
            label.left == view.left
            label.top == view.top
            label.right == view.right
        }
        
        typeLabel.textColor = .darkGray
        typeLabel.font = UIFont(name: "Roboto-Regular", size: 17)
        view.addSubview(typeLabel)
        constrain(typeLabel, nameLabel, view) { type, name, view in
            type.left == view.left
            type.top == name.bottom
            type.right == view.right
            type.bottom == view.bottom
        }
        
        self.contentView.addSubview(view)
        constrain(view, logoImageView, self.contentView) { view, logo, superView in
            view.left == logo.right + 15
            view.centerY == logo.centerY
            view.right == superView.right - 10
        }
    }
    
    func configure() {
        logoImageView.image = UIImage(named: "sample_place_logo")
        nameLabel.text = "Мята Бар"
        typeLabel.text = "Лаунж-бар"
    }
}
