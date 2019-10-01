//
//  ListItemTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/16/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class ListItemTableViewCell: UITableViewCell {
    
    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        label.textColor = .darkGray
        label.font = UIFont(name: "Roboto-Regular", size: 17)
        
        self.contentView.addSubview(label)
        constrain(label, self.contentView) { label, view in
            label.top == view.top + 12
            label.bottom == view.bottom - 12
            label.left == view.left + 20
            label.right == view.right - 20
        }
    }
    
    func configure(with text: String) {
        label.text = text
    }
}
