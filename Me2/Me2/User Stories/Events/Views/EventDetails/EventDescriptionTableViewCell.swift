//
//  EventDescriptionTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/26/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class EventDescriptionTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    let descLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Roboto-Bold", size: 17)
        self.contentView.addSubview(titleLabel)
        constrain(titleLabel, self.contentView) { label, view in
            label.top == view.top + 15
            label.left == view.left + 20
            label.right == view.right - 20
        }
        
        descLabel.textColor = .gray
        descLabel.numberOfLines = 0
        descLabel.font = UIFont(name: "Roboto-Regular", size: 17)
        self.contentView.addSubview(descLabel)
        constrain(descLabel, titleLabel, self.contentView) { desc, title, view in
            desc.top == title.bottom + 12
            desc.leading == title.leading
            desc.trailing == title.trailing
            desc.bottom == view.bottom - 10
        }
    }
    
    func configure(with title: String, and desc: String) {
        titleLabel.text = title
        descLabel.text = desc
    }
}
