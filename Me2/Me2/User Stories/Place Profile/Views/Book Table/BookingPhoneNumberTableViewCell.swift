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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        if text.count < "+# (###) ###-##-##".count {
            textField.text = text.applyPatternOnNumbers(pattern: "+# (###) ###-##-##", replacmentCharacter: "#")
            return true
        }
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            return true
        }
        
        return false
    }
}
