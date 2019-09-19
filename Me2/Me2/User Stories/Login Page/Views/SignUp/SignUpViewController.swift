//
//  SignUpViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 7/29/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import SafariServices

class SignUpViewController: UIViewController {

    @IBOutlet weak var phoneTextField: AttributedTextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var googleSignInView: UIView!
    @IBOutlet weak var facebookSignInView: UIView!
    
    let viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    private func configureViews() {
        googleSignInView.backgroundColor = .white
        googleSignInView.layer.borderColor = UIColor.lightGray.cgColor
        googleSignInView.layer.borderWidth = 1.0
        
        facebookSignInView.backgroundColor = .white
        facebookSignInView.layer.borderColor = UIColor.lightGray.cgColor
        facebookSignInView.layer.borderWidth = 1.0
        
        phoneTextField.delegate = self
        phoneTextField.text = "+7 "
        phoneTextField.addTarget(self, action: #selector(phoneEditing), for: .editingChanged)
        
        disableSendButton()
    }
    
    @objc private func phoneEditing() {
        if phoneTextField.text!.count < 4 {
            phoneTextField.text = "+7 "
        }
        
        if phoneTextField.text!.count == 13 {
            enableSendButton()
        } else {
            disableSendButton()
        }
    }
    
    private func enableSendButton() {
        sendButton.isEnabled = true
        sendButton.alpha = 1.0
    }
    private func disableSendButton() {
        sendButton.isEnabled = false
        sendButton.alpha = 0.5
    }
    
    private func showError(with message: String) {
        errorLabel.text = message
        phoneTextField.layer.borderColor = Color.red.cgColor
        phoneTextField.textColor = Color.red
    }
    private func hideError() {
        errorLabel.text = ""
        phoneTextField.layer.borderColor = Color.gray.cgColor
        phoneTextField.textColor = .black
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        
        viewModel.signUp(with: phoneTextField.text!) { [weak self] (status, message) in
            switch status {
            case .ok:
                
                let vc = Storyboard.confirmCodeViewController() as! ConfirmCodeViewController
                vc.viewModel = ConfirmPinCodeViewModel(activationID: self?.viewModel.phoneActivationID ?? 0)
                self?.navigationController?.pushViewController(vc, animated: true)
                
            case .error:
                
                self?.showError(with: message)
                
            case .fail:
                break
            }
        }
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if errorLabel.text != "" {
            hideError()
        }
    }
}
