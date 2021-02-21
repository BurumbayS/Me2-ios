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
    
    override func configure(parameter: BookingParameter) {
        super.configure(parameter: parameter)
        
        textField.rightViewImage = UIImage(named: "down_arrow")
        titleLabel.text = parameter.type.rawValue
        
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = .init(identifier: "ru")
        datePicker.backgroundColor = .white
        datePicker.addTarget(self, action: #selector(datePicked), for: .valueChanged)
        textField.inputView = datePicker
        textField.delegate = self
        
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        constrain(textField, self.contentView) { textField, view in
            textField.bottom == view.bottom
        }
        
//        bindDynamics()
    }
    
    @objc private func datePicked() {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ru")
        formatter.dateFormat = "dd MMMM yyyy HH:mm"
        textField.text = formatter.string(from: datePicker.date)
    }
}

extension BookingDateAndTimeTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            bookingParameter.filledCorrectly.value = false
        } else {
            bookingParameter.filledCorrectly.value = true
            bookingParameter.data = formatDate()
        }
    }
    
    private func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.string(from: datePicker.date)
    }
}
