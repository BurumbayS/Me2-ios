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
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInWithFacebookView: UIView!
    @IBOutlet weak var signInWithGoogleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.shouldRemoveShadow(true)
        setUpViews()
    }
    
    private func setUpViews() {
        signInWithGoogleView.backgroundColor = .white
        signInWithGoogleView.layer.borderColor = UIColor.lightGray.cgColor
        signInWithGoogleView.layer.borderWidth = 1.0
        
        signInWithFacebookView.backgroundColor = .white
        signInWithFacebookView.layer.borderColor = UIColor.lightGray.cgColor
        signInWithFacebookView.layer.borderWidth = 1.0
    }
    
    @IBAction func signInPressed(_ sender: Any) {
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
    }
}
