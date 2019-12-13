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

struct ByLetterContactsSection {
    let letter: String
    let contacts: [Contact]
}

class MyContactsViewModel {
    var sections = [ContactsListSection.action]
    var actionTypes = [ContactsActionType.addContact, .blockedContacts]
    var byLetterSections = [Int: ByLetterContactsSection]()
    var actions = [VoidBlock?]()
    
    var presenterDelegate: ControllerPresenterDelegate!
    
    var addContactAction: VoidBlock?
    var showBlockedContactsAction: VoidBlock?
    
    var contacts: Dynamic<[Contact]>
    var blockedContacts = [Contact]()
    var updateContactsList: Dynamic<Bool>
    
    var contactsListEditing = false
    var contactsToDelete = [Contact]()
    
    var searchActivated = false
    var searchResults = [Contact]()

    init(presenterDelegate: ControllerPresenterDelegate) {
        self.presenterDelegate = presenterDelegate
        
        contacts = Dynamic([])
        updateContactsList = Dynamic(false)
        
        bindDynamics()
    }
    
    private func bindDynamics() {
        contacts.bind { [weak self] (contacts) in
            self?.groupContactsByLetters(contactsToGroup: contacts)
        }
    }
    
    func configureActions() {
        addContactAction = {
            let vc = Storyboard.addContactViewController() as! AddContactViewController
            vc.viewModel = AddContactViewModel(currentContacts: self.contacts)
            self.presenterDelegate.present(controller: vc, presntationType: .push, completion: nil)
        }
        showBlockedContactsAction = {
            let vc = Storyboard.blockedContactsViewController() as! BlockedContactsViewController
            vc.viewModel = BlockedContactsViewModel(contacts: self.blockedContacts, onUnblockUser: { [weak self] (contact) in
                self?.contacts.value.append(contact)
            })
            self.presenterDelegate.present(controller: vc, presntationType: .push, completion: nil)
        }
        
        actions = [addContactAction, showBlockedContactsAction]
    }
    
    func select(cell : ContactTableViewCell, atIndexPath indexPath: IndexPath) {
        cell.select()
        
        switch cell.checked {
        case .checked:
            if let contact = (searchActivated) ? searchResults[indexPath.row] : byLetterSections[indexPath.section]?.contacts[indexPath.row] {
                contactsToDelete.append(contact)
            }
        default:
            if let contact = (searchActivated) ? searchResults[indexPath.row] : byLetterSections[indexPath.section]?.contacts[indexPath.row] {
                contactsToDelete.removeAll(where: { contact.id == $0.id })
            }
        }
    }
    
    func fetchMyContacts() {
        let url = Network.contact + "/"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    
                    var contacts = [Contact]()
                    for item in json["data"]["results"].arrayValue {
                        if item["blocked"].boolValue {
                            self.blockedContacts.append(Contact(json: item))
                        } else {
                            contacts.append(Contact(json: item))
                        }
                    }
                    
                    self.contacts.value = contacts
                    
                case .failure( _):
                    print(JSON(response.data as Any))
                }
        }
    }
    
    private func groupContactsByLetters(contactsToGroup: [Contact]) {
        var currentContacts = contactsToGroup
        currentContacts.sort(by: { $0.user2.username < $1.user2.username })
        
        var letter = ""
        var contacts = [Contact]()
        
        self.sections = [.action]
        
        for contact in currentContacts {
            if letter != String(contact.user2.username.first!) {
                if letter != "" {
                    sections.append(.byLetterContacts)
                    
                    let section = ByLetterContactsSection(letter: letter, contacts: contacts)
                    byLetterSections[sections.count - 1] = section
                }
                
                letter = String(contact.user2.username.first!)
                contacts = []
            }
            
            contacts.append(contact)
        }
        
        self.updateContactsList.value = true
    }
}
