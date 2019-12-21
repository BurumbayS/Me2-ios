//
//  SetPasswordViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/21/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SetPasswordViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var passwordTextField: AttributedTextField!
    @IBOutlet weak var confirmPasswordTextField: AttributedTextField!
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    let validationError = "Пароль должен содержать не менее 8-ми символов (латиница), в том числе цифры"
    let similarityError = "Пароли не совпадают"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDismissKeyboard()
        configureViews()
        configureNavBar()
    }
    
    private func configureNavBar() {
        navBar.tintColor = .black
        
        setUpBackBarButton(for: navItem)
        navItem.title = "Установить пароль"
    }
    
    private func configureViews() {
        errorLabel.text = ""
        
        passwordTextField.isSecureTextEntry = true
        passwordTextField.rightViewAction = { [weak self] in
            self?.passwordTextField.isSecureTextEntry = !(self?.passwordTextField.isSecureTextEntry)!
        }
        
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.rightViewAction = { [weak self] in
            self?.confirmPasswordTextField.isSecureTextEntry = !(self?.confirmPasswordTextField.isSecureTextEntry)!
        }
        
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        disableSetButton()
    }
    
    private func checkPasswords() {
        guard passwordTextField.text != "" && confirmPasswordTextField.text != "" else { return }
        
        if arePasswordsEqual() && isValidPassword() {
            enableSetButton()
        } else {
            disableSetButton()
        }
        
    }
    
    private func enableSetButton() {
        setButton.isEnabled = true
        setButton.alpha = 1.0
    }
    private func disableSetButton() {
        setButton.isEnabled = false
        setButton.alpha = 0.5
    }
    
    private func arePasswordsEqual() -> Bool {
        if passwordTextField.text != confirmPasswordTextField.text {
            errorLabel.text = similarityError
            confirmPasswordTextField.layer.borderColor = Color.red.cgColor
            return false
        } else {
            errorLabel.text = ""
            confirmPasswordTextField.layer.borderColor = UIColor.lightGray.cgColor
            return true
        }
    }
    
    private func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        
        let valid = NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: passwordTextField.text!)
        if valid {
            errorLabel.text = ""
            passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            errorLabel.text = validationError
            passwordTextField.layer.borderColor = Color.red.cgColor
        }
        
        return valid
    }
    
    @IBAction func setPasswordPressed(_ sender: Any) {
        let url = Network.user + "/new_password/"
        let params = ["password": passwordTextField.text]
        
        Alamofire.request(url, method: .post, parameters: params as Parameters, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    
                    if json["code"].intValue == 0 {
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                case .failure(_):
                    print(JSON(response.data as Any))
                }
        }
    }
}

extension SetPasswordViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkPasswords()
    }
}
