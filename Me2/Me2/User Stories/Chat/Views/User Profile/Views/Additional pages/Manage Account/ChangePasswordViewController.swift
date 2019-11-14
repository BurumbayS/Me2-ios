//
//  ChangePasswordViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/11/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var currentPasswordTextField: AttributedTextField!
    @IBOutlet weak var newPasswordTextField: AttributedTextField!
    @IBOutlet weak var confirmPasswordTextField: AttributedTextField!
    
    let viewModel = ChangePassViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTextFields()
        configureNavBar()
    }
    
    private func configureNavBar() {
        navBar.tintColor = .black
        setUpBackBarButton(for: navItem)
        navItem.title = "Изменить пароль"
    }
    
    private func configureTextFields() {
        configure(textField: currentPasswordTextField)
        configure(textField: newPasswordTextField)
        configure(textField: confirmPasswordTextField)
    }
    
    private func configure(textField: AttributedTextField) {
        textField.delegate = self
        textField.layer.borderWidth = 1
        textField.layer.borderColor = Color.gray.cgColor
        textField.layer.cornerRadius = 5
        textField.isSecureTextEntry = true
        textField.rightViewAction = {
            textField.isSecureTextEntry = !(textField.isSecureTextEntry)
        }
    }

    @IBAction func savePressed(_ sender: Any) {
        guard fieldsAreCorrect() else { return }
        
        viewModel.updatePassword(password:currentPasswordTextField.text!, with: newPasswordTextField.text!) { [weak self] (status, message) in
            switch status {
            case .ok:
                self?.navigationController?.popViewController(animated: true)
            case .error:
                break
            case .fail:
                break
            }
        }
    }
    
    private func fieldsAreCorrect() -> Bool {
        if currentPasswordTextField.text == "" {
            currentPasswordTextField.layer.borderColor = Color.red.cgColor
            return false
        }
        if newPasswordTextField.text == "" {
            newPasswordTextField.layer.borderColor = Color.red.cgColor
            return false
        }
        if confirmPasswordTextField.text == "" {
            confirmPasswordTextField.layer.borderColor = Color.red.cgColor
            return false
        }
        
        if newPasswordTextField.text != confirmPasswordTextField.text {
            return false
        }
        
        return true
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = Color.gray.cgColor
    }
}
