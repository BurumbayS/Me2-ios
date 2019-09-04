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

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var googleSignInView: UIView!
    @IBOutlet weak var facebookSignInView: UIView!
    
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
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        performSegue(withIdentifier: "ToSMSCodeConfirmationSegue", sender: nil)
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
