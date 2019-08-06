//
//  CreateGroupTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/6/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class CreateGroupTableViewCell: UITableViewCell {
    
    let label = UILabel()
    let icon = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        icon.image = UIImage(named: "create_group_icon")
        self.contentView.addSubview(icon)
        constrain(icon, self.contentView) { icon, view in
            icon.left == view.left + 14
            icon.top == view.top + 10
            icon.bottom == view.bottom - 10
            icon.height == 18
            icon.width == 26
        }
        
        label.text = "Создать группу"
        label.font = UIFont(name: "Roboto-Regular", size: 17)
        label.textColor = Color.red
        
        self.contentView.addSubview(label)
        constrain(label, icon, self.contentView) { label, icon, view in
            label.left == icon.right + 14
            label.centerY == icon.centerY
        }
    }
}
