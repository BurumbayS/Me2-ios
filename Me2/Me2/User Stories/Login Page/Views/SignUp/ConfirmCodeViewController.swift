//
//  ConfirmCodeViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 7/30/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import KKPinCodeTextField
import AudioToolbox

class ConfirmCodeViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var codeTextField: KKPinCodeTextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var viewModel: ConfirmPinCodeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        configureNavBar()
    }
    
    private func configureNavBar() {
        navBar.tintColor = .black
        navBar.shouldRemoveShadow(true)
        setUpBackBarButton(for: navItem)
        
        switch viewModel.confirmationType {
        case .onChange:
            navBar.isHidden = false
        default:
            navBar.isHidden = true
        }
    }
    
    private func setUpViews() {
        codeTextField.becomeFirstResponder()
        codeTextField.keyboardToolbar.isHidden = true
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        label.text = "Запросить код подтверждения повторно через 30 сек."
        label.font = UIFont(name: "SFProRounded-Regular", size: 13)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .lightGray
        codeTextField.inputAccessoryView = label
        codeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if codeTextField.text?.count == 4 {
            activate(smsCode: codeTextField.text!)
        } else {
            codeTextField.filledDigitBorderColor = .blue
        }
    }
    
    private func activate(smsCode: String) {
        viewModel.activatePhone(with: smsCode) { [weak self] (status, message) in
            switch status {
            case .ok:
                
                switch self?.viewModel.confirmationType {
                case .onChange?:
                    self?.navigationController?.popViewController(animated: true)
                case .onRegistrartion?:
                    self?.performSegue(withIdentifier: "ToCreatePassSegue", sender: nil)
                default:
                    break
                }
                
            case .error:
                
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                self?.codeTextField.filledDigitBorderColor = .red
                self?.codeTextField.text = ""
                self?.errorLabel.text = message
                
            case .fail:
                break
            }
        }
    }
}
