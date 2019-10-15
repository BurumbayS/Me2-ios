//
//  MenuFileTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/2/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class MenuFileTableViewCell: UITableViewCell {

    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, and icon: UIImage) {
        titleLabel.text = title
        iconImageView.image = icon
    }
    
    private func setUpViews() {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.drawShadow(color: UIColor.darkGray.cgColor, forOpacity: 0.5, forOffset: CGSize(width: 0, height: 0), radius: 2)
        
        iconImageView.contentMode = .scaleAspectFit
        view.addSubview(iconImageView)
        constrain(iconImageView, view) { icon, view in
            icon.left == view.left + 15
            icon.centerY == view.centerY
            icon.width == 22
            icon.height == 22
        }
        
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Roboto-Medium", size: 17)
        view.addSubview(titleLabel)
        constrain(titleLabel, iconImageView, view) { title, icon, view in
            title.top == view.top + 18
            title.bottom == view.bottom - 17
            title.left == icon.right + 10
            title.right == view.right - 15
            title.height == 20
        }
        
        self.contentView.addSubview(view)
        constrain(view, self.contentView) { view, superView in
            view.left == superView.left + 20
            view.right == superView.right - 20
            view.top == superView.top + 10
            view.bottom == superView.bottom - 10
        }
    }
}
