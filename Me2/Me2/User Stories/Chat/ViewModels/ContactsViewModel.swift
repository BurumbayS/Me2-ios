//
//  ContactsViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/8/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ContactsViewModel {
    
    var searchValue: Dynamic<String>!
    let updateSearchResults: Dynamic<Bool>
    var lastSearchVaue = String()
    var searchResults = [Contact]()
    var lastSearchResults = [String]()
    let contactSelectionHandler: ((Int) -> ())?
    
    var byLetterSections = [ByLetterContactsSection]()
    var contacts = [Contact]()
    
    var searchActivated = false
    
    init(onContactSelected: ((Int) -> ())?) {
        self.contactSelectionHandler = onContactSelected
        self.updateSearchResults = Dynamic(false)
    }
    
    func getContacts(completion: ResponseBlock?) {
        let url = Network.contact + "/"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    
                    for item in json["data"]["results"].arrayValue {
                        if !item["blocked"].boolValue {
                            self.contacts.append(Contact(json: item))
                        }
                    }
        
                    self.groupContactsByLetters(contactsToGroup: self.contacts, completion: completion)
                    
                case .failure( _):
                    print(JSON(response.data as Any))
                    completion?(.fail, "")
                }
        }
    }
    
    private func groupContactsByLetters(contactsToGroup: [Contact], completion: ResponseBlock?) {
        var currentContacts = contactsToGroup
        currentContacts.sort(by: { $0.user2.username < $1.user2.username })
        
        var letter = ""
        var contacts = [Contact]()
        
        for contact in currentContacts {
            if letter != String(contact.user2.username.first!) {
                if letter != "" {
                    let byLetterSection = ByLetterContactsSection(letter: letter.uppercased(), contacts: contacts)
                    byLetterSections.append(byLetterSection)
                }
                
                letter = String(contact.user2.username.first!)
                contacts = []
            }
            
            contacts.append(contact)
        }
        
        completion?(.ok, "")
    }
    
    func searchContact(by str: String) {
        searchResults = contacts.filter({ $0.user2.username.lowercased().contains(str.lowercased()) })
        updateSearchResults.value = true
    }
}
