//
//  CreateNewPassViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/3/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class CreateNewPassViewController: UIViewController {

    @IBOutlet weak var newPassTextField: AttributedTextField!
    @IBOutlet weak var confirmedPassTextField: AttributedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    private func configureViews() {
        newPassTextField.delegate = self
        newPassTextField.rightViewAction = { [weak self] in
            self?.newPassTextField.isSecureTextEntry = !(self?.newPassTextField.isSecureTextEntry)!
        }
        confirmedPassTextField.delegate = self
        confirmedPassTextField.rightViewAction = { [weak self] in
            self?.confirmedPassTextField.isSecureTextEntry = !(self?.confirmedPassTextField.isSecureTextEntry)!
        }
    }
}

extension CreateNewPassViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isSecureTextEntry = true
    }
}
