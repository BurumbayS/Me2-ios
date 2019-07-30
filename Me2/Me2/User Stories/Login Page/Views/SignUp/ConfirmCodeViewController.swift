//
//  ConfirmCodeViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 7/30/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class ConfirmCodeViewController: UIViewController {

    @IBOutlet weak var codeStackView: UIStackView!
    @IBOutlet weak var textField: UITextField!
    
    var viewModel = ConfirmPinCodeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    private func setUpViews() {
        codeStackView.arrangedSubviews.forEach { $0.roundCorners(radius: 6) }
        textField.becomeFirstResponder()
        textField.keyboardToolbar.isHidden = true
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateTextField()
        
        let textLength = textField.text?.count ?? 0
        if textLength > 4 {
            
        }
        if textLength < viewModel.pinCode.count {
            
            let index = viewModel.pinCode.count - 1
            viewModel.pinCode.removeLast(1)
            codeStackView.arrangedSubviews[index].backgroundColor = .lightGray
            
            return
            
        }
        
        if viewModel.pinCode.count < 4 {
            if let char = textField.text?.last {
                viewModel.pinCode += String(char)
            }
            let index = viewModel.pinCode.count - 1
            codeStackView.arrangedSubviews[index].backgroundColor = .black
        }
    }
    private func updateTextField() {
        if let text = textField.text {
            if text.count > 4 { textField.text?.removeLast(1) }
        }
    }
}
