//
//  ResetPasswordViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/11/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var phoneNumberTextField: AttributedTextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    let viewModel = ResetPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    private func configureViews() {
        phoneNumberTextField.delegate = self
        phoneNumberTextField.text = "+7 "
        phoneNumberTextField.addTarget(self, action: #selector(phoneEditing), for: .editingChanged)
        
        disableSendButton()
    }
    
    @objc private func phoneEditing() {
        if phoneNumberTextField.text!.count < 4 {
            phoneNumberTextField.text = "+7 "
        }
        
        if phoneNumberTextField.text!.count == 13 {
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
        phoneNumberTextField.layer.borderColor = Color.red.cgColor
        phoneNumberTextField.textColor = Color.red
    }
    private func hideError() {
        errorLabel.text = ""
        phoneNumberTextField.layer.borderColor = Color.gray.cgColor
        phoneNumberTextField.textColor = .black
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        viewModel.resetPassword(for: phoneNumberTextField.text!) { [weak self] (status, message) in
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
}

extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if errorLabel.text != "" {
            hideError()
        }
    }
}
