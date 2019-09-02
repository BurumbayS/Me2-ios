
//
//  PlaceSubsidiariesTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/29/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class PlaceSubsidiariesTableViewCell: UITableViewCell {

    let subsidiariesCountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.tintColor = Color.red
        self.accessoryType = .disclosureIndicator
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with count: Int) {
        subsidiariesCountLabel.text = "\(count)"
    }
    
    private func setUpViews() {
        let titleLabel = UILabel()
        titleLabel.textColor = Color.red
        titleLabel.text = "Филиалы"
        titleLabel.font = UIFont(name: "Roboto-Medium", size: 13)
        self.contentView.addSubview(titleLabel)
        constrain(titleLabel, self.contentView) { title, view in
            title.left == view.left + 20
            title.top == view.top + 10
            title.bottom == view.bottom - 10
        }
        
        subsidiariesCountLabel.textColor = .darkGray
        subsidiariesCountLabel.font = UIFont(name: "Roboto-Medium", size: 13)
        self.contentView.addSubview(subsidiariesCountLabel)
        constrain(subsidiariesCountLabel, titleLabel, self.contentView) { label, title, view in
            label.right == view.right - 10
            label.centerY == title.centerY
        }
    }
}
