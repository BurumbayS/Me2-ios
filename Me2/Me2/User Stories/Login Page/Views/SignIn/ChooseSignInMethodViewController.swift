//
//  ChooseSignInMethodViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 1/16/20.
//  Copyright © 2020 AVSoft. All rights reserved.
//

import UIKit
import AuthenticationServices
import SwiftyJWT

@available(iOS 13.0, *)
class ChooseSignInMethodViewController: UIViewController {
    
    @IBOutlet weak var otherSignInButton: UIButton!
    @IBOutlet weak var appleSignInButton: ASAuthorizationAppleIDButton!
    
    let viewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        configureViews()
    }
    
    private func configureViews() {
        appleSignInButton.addTarget(self, action: #selector(handleLogInWithAppleID), for: .touchUpInside)
        appleSignInButton.layer.borderWidth = 1
        appleSignInButton.layer.borderColor = UIColor.black.cgColor
        appleSignInButton.layer.cornerRadius = 5
        
        otherSignInButton.layer.borderWidth = 1
        otherSignInButton.layer.borderColor = Color.lightGray.cgColor
        otherSignInButton.backgroundColor = Color.lightGray
        otherSignInButton.setTitleColor(UIColor.gray, for: .normal)
        otherSignInButton.setTitle("Другими способами", for: .normal)
    }
    
    @objc func handleLogInWithAppleID() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    @IBAction func otherSignInPressed(_ sender: Any) {
        let vc = Storyboard.signInOrUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

@available(iOS 13.0, *)
extension ChooseSignInMethodViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            if let data = appleIDCredential.authorizationCode, let code = String(data: data, encoding: .utf8) {
                viewModel.signIn(with: .apple, and: code) { (status, message) in
                    switch status {
                    case .ok:
                        window.rootViewController = Storyboard.mainTabsViewController()
                    case .error, .fail:
                        break
                    }
                }
            } else {
                print("No authorization code")
            }
        }
    }
}
