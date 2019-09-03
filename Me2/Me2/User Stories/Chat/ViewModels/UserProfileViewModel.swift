//
//  UserProfileViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/9/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

enum UserProfileSection: String {
    case header = "header"
    case username = "Username"
    case bio = "Био"
    case favourite_places = "Любимые места"
    case block = "block"
    case complain = "complain"
}

class UserProfileViewModel {
    let sections = [UserProfileSection.header, .username, .bio, .favourite_places, .block, .complain]
    
}
