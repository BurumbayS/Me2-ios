//
//  SahreInAppViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/27/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ShareInAppViewModel {
    var contacts = [Contact]()
    var byLetterSections = [ByLetterContactsSection]()
    var selectedContacts = [Contact]()
    
    let data: JSON
    
    init(data: JSON) {
        self.data = data
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
    
    func select(cell : ContactTableViewCell, atIndexPath indexPath: IndexPath) {
        cell.select()
        
        switch cell.checked {
        case .checked:
            let contact = byLetterSections[indexPath.section].contacts[indexPath.row]
            selectedContacts.append(contact)
        default:
            let contact = byLetterSections[indexPath.section].contacts[indexPath.row]
            selectedContacts.removeAll(where: { contact.id == $0.id })
        }
    }
    
    func shareWithContacts() {
        for contact in selectedContacts {
            getRoom(withUser: contact.user2)
        }
    }
    
    private func getRoom(withUser user: ContactUser) {
        let url = Network.chat + "/room/\(user.id)/get_by_user_id/"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    let room = Room(json: json["data"])
                    self.sendMessage(toRoom: room)
                    
                case .failure(_):
                    
                    print(JSON(response.data as Any))
                }
        }
    }
    
    private func sendMessage(toRoom room: Room) {
        let place = ["place": data.dictionaryObject]
        let params = [  "room": room.uuid,
                        "text": "share place",
                        "message_type": "TEXT",
                        "data": place] as [String : Any]
        
        let url = Network.chat + "/message/"
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    
                case .failure(_):
                    
                    print(JSON(response.data as Any))
                    
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
    
}
