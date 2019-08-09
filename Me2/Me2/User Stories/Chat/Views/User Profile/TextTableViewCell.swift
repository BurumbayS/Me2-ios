//
//  TextTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/9/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class TextTableViewCell: UITableViewCell {

    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with textColor: UIColor, text: String) {
        label.textColor = textColor
        label.text = text
    }
    
    private func setUpViews() {
        label.font = UIFont(name: "Roboto-Regular", size: 17)
        label.numberOfLines = 0
        
        self.contentView.addSubview(label)
        constrain(label, self.contentView) { label, view in
            label.left == view.left
            label.top == view.top + 10
            label.bottom == view.bottom - 10
            label.right == view.right - 20
        }
    }
}
