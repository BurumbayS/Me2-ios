//
//  SignInOrUpViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 7/29/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class SignInOrUpViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
    }
    
    private func updateConstraints(for view : UIView, in superview : UIView) {
        constrain(view, superview) { view , superview in
            view.top == superview.top
            view.bottom == superview.bottom
            view.left == superview.left
            view.right == superview.right
        }
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
    }
}
