//
//  LastSearchTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/12/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class LastSearchTableViewCell: UITableViewCell {

    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        let icon = UIImageView(image: UIImage(named: "last_seen_icon"))
        self.contentView.addSubview(icon)
        constrain(icon, self.contentView) { icon, view in
            icon.left == view.left + 20
            icon.centerY == view.centerY
        }
        
        label.textColor = .gray
        label.font = UIFont(name: "Roboto-Regular", size: 17)
        self.contentView.addSubview(label)
        constrain(label, icon, self.contentView) { label, icon, view in
            label.left == icon.right + 10
            label.top == view.top + 7.5
            label.bottom == view.bottom - 7.5
        }
    }
    
    func configure(with text: String) {
        label.text = text
    }
}
