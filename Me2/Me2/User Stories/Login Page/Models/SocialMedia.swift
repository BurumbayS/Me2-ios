//
//  SocialMedia.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/10/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import GoogleSignIn

enum SocialMediaType: String {
    case google = "google"
    case facebook = "facebook"
}

class SocialMedia: NSObject {
    static let shared = SocialMedia()
    
    private var signInCompletion: ((String) -> ())?
    
    func signIn(to socialMedia : SocialMediaType, completion: ((String) -> ())?) {
        signInCompletion = completion
        
        switch socialMedia {
        case .google:
            GIDSignIn.sharedInstance()?.delegate = self
            GIDSignIn.sharedInstance()?.signIn()
        case .facebook:
            break
        }
    }
}

extension SocialMedia: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            let access_token = user.authentication.accessToken
            
            signInCompletion?(access_token ?? "")
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Did disconnect")
    }
}
