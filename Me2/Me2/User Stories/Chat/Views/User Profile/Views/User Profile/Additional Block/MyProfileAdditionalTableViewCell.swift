
//
//  MyProfileAdditionalTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/2/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class MyProfileAdditionalTableViewCell: UITableViewCell {
    
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: MyProfileAdditionalBlockCell) {
        iconImageView.image = item.icon
        titleLabel.text = item.rawValue
        titleLabel.textColor = (item == .logout) ? Color.red : .darkGray
    }
    
    private func setUpViews() {
        let line = UIView()
        line.backgroundColor = Color.gray
        self.contentView.addSubview(line)
        constrain(line, self.contentView) { line, view in
            line.left == view.left + 20
            line.height == 1
            line.right == view.right
            line.top == view.top
        }
        
        iconImageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(iconImageView)
        constrain(iconImageView, self.contentView) { icon, view in
            icon.left == view.left + 20
            icon.centerY == view.centerY
            icon.height == 16
            icon.width == 16
        }
        
        titleLabel.textColor = .darkGray
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        self.contentView.addSubview(titleLabel)
        constrain(titleLabel, iconImageView, self.contentView) { label, icon, view in
            label.left == icon.right + 10
            label.top == view.top + 15
            label.bottom == view.bottom - 15
            label.right == view.right - 10
        }
    }

}
