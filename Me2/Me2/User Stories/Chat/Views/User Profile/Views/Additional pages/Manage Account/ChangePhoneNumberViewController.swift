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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTextField()
    }
    
    private func configureNavBar() {
        navBar.tintColor = .black
        navItem.title = "Изменить номер телефонв"
        setUpBackBarButton(for: navItem)
    }
    
    private func configureTextField() {
        phoneNumberTextField.keyboardType = .numberPad
        phoneNumberTextField.font = UIFont(name: "Roboto-Regular", size: 15)
        phoneNumberTextField.layer.borderWidth = 1
        phoneNumberTextField.layer.borderColor = Color.gray.cgColor
        phoneNumberTextField.layer.cornerRadius = 5
        phoneNumberTextField.delegate = self
    }

    @IBAction func changePressed(_ sender: Any) {
        let vc = Storyboard.confirmCodeViewController() as! ConfirmCodeViewController
        vc.viewModel = ConfirmPinCodeViewModel(activationID: 0, confirmationType: .onChange)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ChangePhoneNumberViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        let pattern = "+# (###) ###-####"
        
        if text.count == pattern.count && !string.isBackspace() { return false }
        
        textField.text = text.applyPatternOnNumbers(pattern: pattern, replacmentCharacter: "#")
        
        return true
    }
}
