//
//  BookingPhoneNumberTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/30/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class BookingPhoneNumberTableViewCell: BookingTableViewCell {
    
    var phoneNumber = String()
    
    func configure() {
        titleLabel.text = BookingParameters.phoneNumber.rawValue
        
        textField.delegate = self
        textField.keyboardType = .phonePad
        
        addCheckBoxes()
    }

    private func addCheckBoxes() {
        let callMeCheckBox = CheckBox()
        callMeCheckBox.configure(with: "Позвонить мне")
        self.contentView.addSubview(callMeCheckBox)
        constrain(callMeCheckBox, textField, self.contentView) { box, label, view in
            box.left == view.left + 20
            box.top == label.bottom + 20
            box.right == view.right - 20
        }
        
        let rememberMeCheckBox = CheckBox()
        rememberMeCheckBox.configure(with: "Запомнить")
        self.contentView.addSubview(rememberMeCheckBox)
        constrain(rememberMeCheckBox, callMeCheckBox, self.contentView) { box1, box2, view in
            box1.left == view.left + 20
            box1.top == box2.bottom + 15
            box1.right == view.right - 20
            box1.bottom == view.bottom
        }
    }
}

extension BookingPhoneNumberTableViewCell: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if phoneNumber.count < 11 {
//            phoneNumber += string
//        }
//
//        let cleanPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
//        let mask = "+X (XXX) XXX-XXXX"
//
//        var result = ""
//        var index = cleanPhoneNumber.startIndex
//        for ch in mask where index < cleanPhoneNumber.endIndex {
//            if ch == "X" {
//                result.append(cleanPhoneNumber[index])
//                index = cleanPhoneNumber.index(after: index)
//            } else {
//                result.append(ch)
//            }
//        }
//
//        textField.text = result
//
//        return true
//    }
}
