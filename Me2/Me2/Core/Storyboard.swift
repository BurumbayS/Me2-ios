//
//  Storyboard.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 7/29/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case login = "LoginPage"
    
    private var storyboard: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}

extension Storyboard {
    static var signInOrUpViewController = {
        return login.storyboard.instantiateViewController(withIdentifier: "SignInOrUpViewController")
    }
}
