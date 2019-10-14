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
            textField.layer.borderWidth = 1.0
            textField.layer.cornerRadius = 5
            textField.layer.borderColor = Color.red.cgColor
            
            bookingParameter.filledCorrectly = false
        } else {
            bookingParameter.filledCorrectly = true
            bookingParameter.data = textField.text
            
            textField.layer.borderWidth = 0
        }
    }
}
