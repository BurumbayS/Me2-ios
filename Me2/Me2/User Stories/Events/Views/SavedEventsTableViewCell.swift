//
//  SavedEventsTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/24/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class SavedEventsTableViewCell: UITableViewCell {

    let badgeView = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addUnderline(with: Color.gray, and: CGSize(width: UIScreen.main.bounds.width, height: self.frame.height))
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with savedEventsCount: Int) {
        badgeView.setTitle("\(savedEventsCount)", for: .normal)
    }
    
    private func setUpViews() {
        let flag = UIImageView(image: UIImage(named: "selected_flag"))
        self.contentView.addSubview(flag)
        constrain(flag, self.contentView) { flag, view in
            flag.left == view.left + 20
            flag.height == 18
            flag.width == 14
            flag.top == view.top + 15
            flag.bottom == view.bottom - 15
        }
        
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Roboto-Medium", size: 15)
        label.text = "Сохраненные"
        
        self.contentView.addSubview(label)
        constrain(label, flag, self.contentView) { label, flag, view in
            label.left == flag.right + 10
            label.centerY == flag.centerY
        }
        
        badgeView.backgroundColor = Color.red
        badgeView.setTitleColor(.white, for: .normal)
        badgeView.layer.cornerRadius = 8
        badgeView.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 11)
        self.contentView.addSubview(badgeView)
        constrain(badgeView, self.contentView) { badge, view in
            badge.right == view.right
            badge.height == 16
            badge.width == 16
            badge.centerY == view.centerY
        }
    }
}
