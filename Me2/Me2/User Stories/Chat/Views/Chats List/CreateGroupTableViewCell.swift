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
        label.text = "Создать группу"
        label.font = UIFont(name: "Roboto-Regular", size: 17)
        label.textColor = Color.red
        
        self.contentView.addSubview(label)
        constrain(label, self.contentView) { label, view in
            label.left == view.left + 20
            label.top == view.top + 10
            label.bottom == view.bottom - 10
            label.height == 20
        }
    }
}
