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
    case events = "Events"
    
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
    static var mapSearchViewController = {
        return map.storyboard.instantiateViewController(withIdentifier: "MapSearchViewController")
    }
    static var mapSearchFilterViewController = {
        return map.storyboard.instantiateViewController(withIdentifier: "MapSearchFilterViewController")
    }
    static var listForMapFilterViewController = {
        return map.storyboard.instantiateViewController(withIdentifier: "ListForMapFilterViewController")
    }
    
    //Chat tab view controllers
    static var chatTabViewController = {
        return chat.storyboard.instantiateViewController(withIdentifier: "ChatTabViewController")
    }
    static var chatViewController = {
        return chat.storyboard.instantiateViewController(withIdentifier: "ChatViewController")
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
    static var editProfileViewController = {
        return profile.storyboard.instantiateViewController(withIdentifier: "EditProfileViewController")
    }
    static var aboutAppViewController = {
        return profile.storyboard.instantiateViewController(withIdentifier: "AboutAppViewController")
    }
    static var feedbackViewController = {
        return profile.storyboard.instantiateViewController(withIdentifier: "FeedbackViewController")
    }
    static var notificationsViewController = {
        return profile.storyboard.instantiateViewController(withIdentifier: "NotificationsViewController")
    }
    static var manageAccountViewController = {
        return profile.storyboard.instantiateViewController(withIdentifier: "ManageAccountViewController")
    }
    static var changePasswordViewController = {
        return profile.storyboard.instantiateViewController(withIdentifier: "ChangePasswordViewController")
    }
    
    //Place profile controllers
    static var placeProfileViewController = {
        return placeProfile.storyboard.instantiateViewController(withIdentifier: "PlaceProfileViewController")
    }
    
    //Events tab controllers
    static var eventsTabViewController = {
        return events.storyboard.instantiateViewController(withIdentifier: "EventsTabViewController")
    }
    static var eventsSearchViewController = {
        return events.storyboard.instantiateViewController(withIdentifier: "EventsSearchViewController")
    }
    static var listOfAllViewController = {
        return events.storyboard.instantiateViewController(withIdentifier: "ListOfAllViewController")
    }
    static var eventDetailsViewController = {
        return events.storyboard.instantiateViewController(withIdentifier: "EventDetailsViewController")
    }
    static var eventFilterViewController = {
        return events.storyboard.instantiateViewController(withIdentifier: "EventFilterViewController")
    }
    static var writeReviewViewController = {
        return placeProfile.storyboard.instantiateViewController(withIdentifier: "WriteReviewViewController")
    }
    static var bookTableViewController = {
        return placeProfile.storyboard.instantiateViewController(withIdentifier: "BookTableViewController")
    }
    static var addGuestsViewController = {
        return placeProfile.storyboard.instantiateViewController(withIdentifier: "AddGuestsViewController")
    }
}
