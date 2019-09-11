//
//  SignInViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 7/29/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInDelegate {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginTextField: AttributedTextField!
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
    
    private func showError(with message: String) {
        errorLabel.text = message
        loginTextField.layer.borderColor = Color.red.cgColor
        loginTextField.textColor = Color.red
        passwordTextField.layer.borderColor = Color.red.cgColor
        passwordTextField.textColor = Color.red
    }
    private func hideError() {
        errorLabel.text = ""
        loginTextField.layer.borderColor = Color.gray.cgColor
        loginTextField.textColor = .black
        passwordTextField.layer.borderColor = Color.gray.cgColor
        passwordTextField.textColor = .black
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        let social = SocialMedia(delegate: self)
        social.signIn(to: .google) { (token) in
            print(token)
        }
//        viewModel.signIn(with: loginTextField.text!, and: passwordTextField.text!) { [weak self] (status, message) in
//            switch status {
//            case .ok:
//                window.rootViewController = Storyboard.mapViewController()
//            case .error:
//                self?.showError(with: message)
//            case .fail:
//                print("fail")
//            }
//        }
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if errorLabel.text != "" {
            hideError()
        }
    }
}
