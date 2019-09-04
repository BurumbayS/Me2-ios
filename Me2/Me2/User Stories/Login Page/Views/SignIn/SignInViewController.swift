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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        passwordTextField.delegate = self
        passwordTextField.rightViewAction = { [weak self] in
            self?.passwordTextField.isSecureTextEntry = !(self?.passwordTextField.isSecureTextEntry)!
        }
    }
    
    @IBAction func signInPressed(_ sender: Any) {
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isSecureTextEntry = true
    }
}
