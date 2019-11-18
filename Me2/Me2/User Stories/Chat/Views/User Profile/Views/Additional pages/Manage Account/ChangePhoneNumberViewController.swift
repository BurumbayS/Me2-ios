//
//  ChangePhoneNumberViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/11/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class ChangePhoneNumberViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var phoneNumberTextField: AttributedTextField!
    @IBOutlet weak var changeButton: UIButton!
    
    let viewModel = ChangePhoneViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureViews()
    }
    
    private func configureNavBar() {
        navBar.tintColor = .black
        navItem.title = "Изменить номер телефонв"
        setUpBackBarButton(for: navItem)
    }
    
    private func configureViews() {
        disableChangeButton()
        
        configureTextField()
    }
    
    private func configureTextField() {
        phoneNumberTextField.keyboardType = .numberPad
        phoneNumberTextField.font = UIFont(name: "Roboto-Regular", size: 15)
        phoneNumberTextField.layer.borderWidth = 1
        phoneNumberTextField.layer.borderColor = Color.gray.cgColor
        phoneNumberTextField.layer.cornerRadius = 5
        phoneNumberTextField.delegate = self
    }
    
    private func enableChangeButton() {
        changeButton.isEnabled = true
        changeButton.alpha = 1.0
    }
    private func disableChangeButton() {
        changeButton.isEnabled = false
        changeButton.alpha = 0.5
    }

    @IBAction func changePressed(_ sender: Any) {
        viewModel.updatePhone(with: phoneNumberTextField.text!) { [weak self] (status, message) in
            switch status {
            case .ok:
                
                let vc = Storyboard.confirmCodeViewController() as! ConfirmCodeViewController
                vc.viewModel = ConfirmPinCodeViewModel(activationID: (self?.viewModel.activationID)!, confirmationType: .onChange)
                self?.navigationController?.pushViewController(vc, animated: true)
                
            case .error:
                break
            case .fail:
                break
            }
        }
    }
}

extension ChangePhoneNumberViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        if text.count == viewModel.phonePattern.count && !string.isBackspace() { return false } else { disableChangeButton() }
        
        textField.text = text.applyPatternOnNumbers(pattern: viewModel.phonePattern, replacmentCharacter: "#")
        
        if textField.text!.count + 1 == viewModel.phonePattern.count && !string.isBackspace() {
            enableChangeButton()
        } else {
            disableChangeButton()
        }
        
        return true
    }
}
