//
//  BookingUsernameTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/30/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class BookingUsernameTableViewCell: BookingTableViewCell {

    func configure() {
        titleLabel.text = BookingParameters.username.rawValue
        constrain(textField, self.contentView) { textField, view in
            textField.bottom == view.bottom
        }
    }

}
