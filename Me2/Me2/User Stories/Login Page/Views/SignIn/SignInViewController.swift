//
//  SignInViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 7/29/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: AttributedTextField!
    @IBOutlet weak var signInWithFacebookView: UIView!
    @IBOutlet weak var signInWithGoogleView: UIView!
    @IBOutlet weak var signInButton: UIButton!
    
    let viewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.makeTransparentBar()
        navigationController?.navigationBar.shouldRemoveShadow(true)
        configureViews()
    }
    
    private func configureViews() {
        signInWithGoogleView.backgroundColor = .white
        signInWithGoogleView.layer.borderColor = UIColor.lightGray.cgColor
        signInWithGoogleView.layer.borderWidth = 1.0
        
        signInWithFacebookView.backgroundColor = .white
        signInWithFacebookView.layer.borderColor = UIColor.lightGray.cgColor
        signInWithFacebookView.layer.borderWidth = 1.0
        
        loginTextField.delegate = self
        loginTextField.tag = 1
        passwordTextField.delegate = self
        passwordTextField.tag = 2
        passwordTextField.rightViewAction = { [weak self] in
            self?.passwordTextField.isSecureTextEntry = !(self?.passwordTextField.isSecureTextEntry)!
        }
        
        disableSignInButton()
    }
    
    private func enableSignInButton() {
        signInButton.isEnabled = true
        signInButton.alpha = 1.0
    }
    private func disableSignInButton() {
        signInButton.isEnabled = false
        signInButton.alpha = 0.5
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        viewModel.signIn(with: loginTextField.text!, and: passwordTextField.text!)
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        //check for password text field by tag
        textField.isSecureTextEntry = (textField.tag == 2) ? true : false
        
        if loginTextField.text != "" && passwordTextField.text != "" {
            enableSignInButton()
        } else {
            disableSignInButton()
        }
    }
}
