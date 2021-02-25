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
    let callMeCheckBox = CheckBox()
    let rememberMeCheckBox = CheckBox()
    
    override func configure(parameter: BookingParameter) {
        super.configure(parameter: parameter)
        
        titleLabel.text = parameter.type.rawValue
        
        textField.delegate = self
        textField.keyboardType = .phonePad
        
        addCheckBoxes()
    }
    
    private func addCheckBoxes() {
        callMeCheckBox.configure(with: "Позвонить мне")
        self.contentView.addSubview(callMeCheckBox)
        constrain(callMeCheckBox, textField, self.contentView) { box, label, view in
            box.left == view.left + 20
            box.top == label.bottom + 20
            box.right == view.right - 20
        }
        
        rememberMeCheckBox.configure(with: "Запомнить")
        self.contentView.addSubview(rememberMeCheckBox)
        constrain(rememberMeCheckBox, callMeCheckBox, self.contentView) { box1, box2, view in
            box1.left == view.left + 20
            box1.top == box2.bottom + 15
            box1.right == view.right - 20
            box1.bottom == view.bottom
        }
    }
    
    private func handleCheckBoxes() {
        bookingParameter.callback = callMeCheckBox.isChecked
        bookingParameter.remember = rememberMeCheckBox.isChecked
    }
}

extension BookingPhoneNumberTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        if text.count < "+# (###) ###-##-##".count {
            textField.text = text.applyPatternOnNumbers(pattern: "+# (###) ###-##-##", replacmentCharacter: "#")
            guard let phone = textField.text else { return true }
            validate(phone: phone)
            return true
        }
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            return true
        }
        
        return false
    }
    
    private func validate(phone: String) {
        if phone.count + 1 < "+# (###) ###-##-##".count {
            bookingParameter.filledCorrectly.value = false
        } else {
            bookingParameter.filledCorrectly.value = true
            bookingParameter.data = textField.text
            
            handleCheckBoxes()
        }
    }
}
