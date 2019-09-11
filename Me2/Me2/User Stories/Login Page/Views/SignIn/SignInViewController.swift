//
//  SignInViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 7/29/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignInViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginTextField: AttributedTextField!
    @IBOutlet weak var passwordTextField: AttributedTextField!
    @IBOutlet weak var signInWithFacebookView: UIView!
    @IBOutlet weak var signInWithGoogleView: UIView!
    @IBOutlet weak var signInButton: UIButton!
    
    let viewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        navigationController?.navigationBar.makeTransparentBar()
        navigationController?.navigationBar.shouldRemoveShadow(true)
        configureViews()
    }
    
    private func configureViews() {
        signInWithGoogleView.backgroundColor = .white
        signInWithGoogleView.layer.borderColor = UIColor.lightGray.cgColor
        signInWithGoogleView.layer.borderWidth = 1.0
        var tap = UITapGestureRecognizer(target: self, action: #selector(signInWithGoogle))
        signInWithGoogleView.addGestureRecognizer(tap)
        
        signInWithFacebookView.backgroundColor = .white
        signInWithFacebookView.layer.borderColor = UIColor.lightGray.cgColor
        signInWithFacebookView.layer.borderWidth = 1.0
        tap = UITapGestureRecognizer(target: self, action: #selector(signInWithFacebook))
        signInWithFacebookView.addGestureRecognizer(tap)
        
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
    
    @objc private func signInWithGoogle() {
        showPrivacyPolicy { [weak self] (accepted) in
            switch accepted {
            case true:
                SocialMedia.shared.signIn(to: .google) { (token) in
                    self?.viewModel.signIn(with: .google, and: token, completion: { (status, message) in
                        switch status {
                        case .ok:
                            window.rootViewController = Storyboard.mainTabsViewController()
                        case .error:
                            break
                        case .fail:
                            break
                        }
                    })
                }
            case false:
                break
            }
        }
    }
    
    @objc private func signInWithFacebook() {
        
    }
    
    private func showPrivacyPolicy(completion: ((Bool) -> ())?) {
        let vc = Storyboard.privacyPolicyViewController() as! PrivacyPolicyViewController
        vc.acceptionHandler = completion
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        showPrivacyPolicy { [weak self] (accepted) in
            switch accepted {
            case true:
                let vc = Storyboard.signUpViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            case false:
                break
            }
        }
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        viewModel.signIn(with: loginTextField.text!, and: passwordTextField.text!) { [weak self] (status, message) in
            switch status {
            case .ok:
                window.rootViewController = Storyboard.mainTabsViewController()
            case .error:
                self?.showError(with: message)
            case .fail:
                print("fail")
            }
        }
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
