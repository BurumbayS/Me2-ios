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

    override func configure(parameter: BookingParameter) {
        super.configure(parameter: parameter)
        
        textField.delegate = self
        titleLabel.text = parameter.type.rawValue
        constrain(textField, self.contentView) { textField, view in
            textField.bottom == view.bottom
        }
    }

}

extension BookingUsernameTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" { 
            bookingParameter.filledCorrectly.value = false
        } else {
            bookingParameter.filledCorrectly.value = true
            bookingParameter.data = textField.text
        }
    }
}
