//
//  Storyboard.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/2/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case main = "Main"
    case loginPage = "LoginPage"
    case map = "Map"
    case chat = "Chat"
    case profile = "Profile"
    case placeProfile = "PlaceProfile"
    
    private var storyboard: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}

extension Storyboard {
    //Main Tabs view controller
    static var mainTabsViewController = {
        return main.storyboard.instantiateViewController(withIdentifier: "MainTabsViewController")
    }
    
    //Login page view controllers
    static var signInOrUpViewController = {
        return loginPage.storyboard.instantiateViewController(withIdentifier: "SignInOrUpViewController")
    }
    static var accessCodeViewController = {
        return loginPage.storyboard.instantiateViewController(withIdentifier: "AccessCodeViewController")
    }
    static var privacyPolicyViewController = {
        return loginPage.storyboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController")
    }
    static var signUpViewController = {
        return loginPage.storyboard.instantiateViewController(withIdentifier: "SignUpViewController")
    }
    static var confirmCodeViewController = {
        return loginPage.storyboard.instantiateViewController(withIdentifier: "ConfirmCodeViewController")
    }
    
    //Map tab view controllers
    static var mapViewController = {
        return map.storyboard.instantiateViewController(withIdentifier: "MapViewController")
    }
    
    //Chat tab view controllers
    static var chatTabViewController = {
        return chat.storyboard.instantiateViewController(withIdentifier: "ChatTabViewController")
    }
    static var chatsListViewController = {
        return chat.storyboard.instantiateViewController(withIdentifier: "ChatsListViewController")
    }
    static var liveChatViewController = {
        return chat.storyboard.instantiateViewController(withIdentifier: "LiveChatViewController")
    }
    static var contactsViewController = {
        return chat.storyboard.instantiateViewController(withIdentifier: "ContactsViewController")
    }
    static var createGroupViewController = {
        return chat.storyboard.instantiateViewController(withIdentifier: "CreateGroupViewController")
    }
    static var modifyGroupViewController = {
        return chat.storyboard.instantiateViewController(withIdentifier: "ModifyGroupViewController")
    }
    
    //Profile tab view controllers
    static var userProfileViewController = {
        return profile.storyboard.instantiateViewController(withIdentifier: "UserProfileViewController")
    }
    static var favouritePlacesViewController = {
        return profile.storyboard.instantiateViewController(withIdentifier: "FavouritePlacesViewController")
    }
    
    //Place profile controllers
    static var placeProfileViewController = {
        return placeProfile.storyboard.instantiateViewController(withIdentifier: "PlaceProfileViewController")
    }
}
