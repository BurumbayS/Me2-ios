//
//  ConfirmPasswordTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/20/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class ConfirmPasswordTableViewCell: UITableViewCell {

    @IBOutlet weak var passwordTextField: AttributedTextField!
    
    var password: Dynamic<String>!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
    }
    
    func configure(password: Dynamic<String>) {
        self.password = password
    }
    
    private func configureViews() {
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        
        passwordTextField.rightViewAction = { [weak self] in
            self?.passwordTextField.isSecureTextEntry = !(self?.passwordTextField.isSecureTextEntry)!
        }
    }
}

extension ConfirmPasswordTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        password.value = textField.text ?? ""
    }
}
