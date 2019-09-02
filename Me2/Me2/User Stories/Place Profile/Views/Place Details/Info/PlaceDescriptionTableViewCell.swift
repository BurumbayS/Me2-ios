//
//  PlaceDescriptionTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/28/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class PlaceDescriptionTableViewCell: UITableViewCell {

    let descriptionLabel = UILabel()
    let moreTextButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text : String) {
        descriptionLabel.text = text
    }
    
    private func setUpViews() {
        descriptionLabel.textColor = .black
        descriptionLabel.font = UIFont(name: "Roboto-Regular", size: 17)
        descriptionLabel.numberOfLines = 0
        
        self.contentView.addSubview(descriptionLabel)
        constrain(descriptionLabel, self.contentView) { desc, view in
            desc.left == view.left + 20
            desc.right == view.right - 20
            desc.top == view.top + 20
            desc.height == 60
        }
        
        moreTextButton.setTitle("Подробнее", for: .normal)
        moreTextButton.setTitleColor(Color.red, for: .normal)
        moreTextButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 13)
        
        self.contentView.addSubview(moreTextButton)
        constrain(moreTextButton, descriptionLabel, self.contentView) { btn, desc, view in
            btn.trailing == desc.trailing
            btn.top == desc.bottom
            btn.height == 20
            btn.width == 100
            btn.bottom == view.bottom - 20
        }
    }
}
