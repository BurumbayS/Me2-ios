//
//  BookingDateAndTimeTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/30/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class BookingDateAndTimeTableViewCell: BookingTableViewCell {

    let datePicker = UIDatePicker()
    
    func configure() {
        textField.rightViewImage = UIImage(named: "down_arrow")
        titleLabel.text = BookingParameters.dateTime.rawValue
        
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = .init(identifier: "ru")
        datePicker.backgroundColor = .white
        datePicker.addTarget(self, action: #selector(datePicked), for: .valueChanged)
        textField.inputView = datePicker
        
        constrain(textField, self.contentView) { textField, view in
            textField.bottom == view.bottom
        }
    }
    
    @objc private func datePicked() {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ru")
        formatter.dateFormat = "dd MMMM yyyy HH:mm"
        textField.text = formatter.string(from: datePicker.date)
    }
}
