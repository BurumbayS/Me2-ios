//
//  BlockedContactsViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/28/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class BlockedContactsViewModel {
    var contacts = [Contact]()
    var searchResults: Dynamic<[Contact]>
    var searchActivated = false
    
    var unblockHandler: ((Contact) -> Void)?
    
    init(contacts: [Contact], onUnblockUser: ((Contact) -> Void)?) {
        self.contacts = contacts
        self.unblockHandler = onUnblockUser
        self.searchResults = Dynamic([])
    }

    func unblockContact(atIndex index: Int, completion: ResponseBlock?) {
        let contact = contacts[index]
        let url = Network.contact + "/\(contact.id)/unblock/"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(.fail, "")
                }
        }
    }
    
    func searchUser(withPrefix substring: String) {
        searchActivated = true
        
        if substring != "" {
            searchResults.value = contacts.filter({ $0.user2.username.lowercased().contains(substring.lowercased()) })
        } else {
            searchResults.value = contacts
        }
    }
}
