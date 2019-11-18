//
//  ContactsActionTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/17/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class ContactsActionTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(actionType: ContactsActionType) {
        iconImageView.image = actionType.icon
        titleLabel.text = actionType.title
        titleLabel.textColor = actionType.titleColor
    }
}
