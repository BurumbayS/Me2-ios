//
//  MyContactsViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/17/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

enum ContactsActionType {
    case inviteFriend
    case synchronizeContacts
    case addContact
    case blockedContacts
    
    var icon: UIImage {
        switch self {
        case .inviteFriend:
            return UIImage(named: "invite_friends_icon")!
        case .synchronizeContacts:
            return UIImage(named: "synchronize_contacts_icon")!
        case .addContact:
            return UIImage(named: "add_contact_icon")!
        case .blockedContacts:
            return UIImage(named: "blocked_contacts_icon")!
        }
    }
    
    var title: String {
        switch self {
        case .inviteFriend:
            return "Пригласить друзей"
        case .synchronizeContacts:
            return "Синхронизировать контакты"
        case .addContact:
            return "Добавить контакт"
        case .blockedContacts:
            return "Заблокированные"
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .blockedContacts:
            return .gray
        default:
            return Color.blue
        }
    }
}

enum ContactsListSection {
    case action
    case searchResults
    case synchronizedContacts
    case byLetterContacts
    
    var title: String  {
        switch self {
        case .action:
            return ""
        case .searchResults:
            return "Результаты поиска"
        case .synchronizedContacts:
            return "Контакты"
        case .byLetterContacts:
            return ""
        }
    }
}

class MyContactsViewModel {
    var sections = [ContactsListSection.action]
    var actionTypes = [ContactsActionType.addContact, .blockedContacts]
    var actions = [VoidBlock?]()
    
    var presenterDelegate: ControllerPresenterDelegate!
    
    var addContactAction: VoidBlock?
    var showBlockedContactsAction: VoidBlock?

    init(presenterDelegate: ControllerPresenterDelegate) {
        self.presenterDelegate = presenterDelegate
    }
    
    func configureActions() {
        addContactAction = {
            let vc = Storyboard.addContactViewController()
            self.presenterDelegate.present(controller: vc, presntationType: .push)
        }
        showBlockedContactsAction = {
            print("Show blocked users")
        }
        
        actions = [addContactAction, showBlockedContactsAction]
    }
}
