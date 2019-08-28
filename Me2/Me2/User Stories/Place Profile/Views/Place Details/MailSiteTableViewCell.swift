//
//  MailSiteTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/28/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class MailSiteTableViewCell: UITableViewCell {

    let iconImageView = UIImageView()
    let linkLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withWebSite site: String) {
        iconImageView.image = UIImage(named: "internet")
        linkLabel.text = site
    }
    
    func configure(withEmail email: String) {
        iconImageView.image = UIImage(named: "email")
        linkLabel.text = email
    }
    
    private func setUpViews() {
        self.contentView.addSubview(iconImageView)
        constrain(iconImageView, self.contentView) { icon, view in
            icon.left == view.left + 20
            icon.width == 20
            icon.height == 20
            icon.top == view.top + 10
            icon.bottom == view.bottom - 10
        }
        
        linkLabel.textColor = Color.blue
        linkLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        self.contentView.addSubview(linkLabel)
        constrain(linkLabel, iconImageView, self.contentView) { link, icon, view in
            link.left == icon.right + 15
            link.centerY == icon.centerY
            link.right == view.right - 22
        }
    }
}
