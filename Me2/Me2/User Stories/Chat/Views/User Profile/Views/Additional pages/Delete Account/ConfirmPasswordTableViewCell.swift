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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
    }
    
    private func configureViews() {
        passwordTextField.isSecureTextEntry = true
        
        passwordTextField.rightViewAction = { [weak self] in
            self?.passwordTextField.isSecureTextEntry = !(self?.passwordTextField.isSecureTextEntry)!
        }
    }
}
