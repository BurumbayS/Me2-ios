//
//  CreateNewPassViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/3/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class CreateNewPassViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var newPassTextField: AttributedTextField!
    @IBOutlet weak var confirmedPassTextField: AttributedTextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    let viewModel = CreateNewPassViewModel()
    
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
    
    private func enableConfirmButton() {
        confirmButton.isEnabled = true
        confirmButton.alpha = 1.0
    }
    private func disableConfirmButton() {
        confirmButton.isEnabled = false
        confirmButton.alpha = 0.5
    }
    
    private func checkPasswords() {
        if arePasswordsEqual() && isValidPassword() {
            enableConfirmButton()
        } else {
            disableConfirmButton()
        }
        
    }
    
    private func arePasswordsEqual() -> Bool {
        if newPassTextField.text != "" && confirmedPassTextField.text != "" && newPassTextField.text != confirmedPassTextField.text {
            errorLabel.text = "Пароли не совпадают"
            return false
        } else {
            errorLabel.text = ""
            return true
        }
    }
    
    private func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: newPassTextField.text!)
    }
    
    @IBAction func confirmPressed(_ sender: Any) {
        viewModel.updatePass(with: newPassTextField.text!) { [weak self] (status, message) in
            switch status {
            case .ok:
                window.rootViewController = Storyboard.mainTabsViewController()
            case .error:
                self?.errorLabel.text = message
            case .fail:
                break
            }
        }
    }
}

extension CreateNewPassViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isSecureTextEntry = true
        
        checkPasswords()
    }
}
