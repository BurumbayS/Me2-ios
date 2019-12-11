//
//  AddContactViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/18/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON
import Contacts

class AddContactViewModel {
    var sections = [ContactsListSection.action]
    var actionTypes = [ContactsActionType.inviteFriend, .synchronizeContacts]
    var actions = [VoidBlock?]()
    
    var myContacts: Dynamic<[Contact]>!
    var contactUsers = [ContactUser]()
    
    var synchronizedUsers = [ContactUser]()
    var contactsSynchronized: Dynamic<Bool>
    
    var searchResults = [ContactUser]()
    var updateSearchResults: Dynamic<Bool>
    
    var inviteFriends: VoidBlock?
    var synchronizeContacts: VoidBlock?
    
    var parentVC: UIViewController!
    
    init(currentContacts: Dynamic<[Contact]>) {
        self.myContacts = currentContacts
        for contact in currentContacts.value {
            contactUsers.append(contact.user2)
        }
        
        contactsSynchronized = Dynamic(false)
        updateSearchResults = Dynamic(false)
    }
    
    func configureActions() {
        inviteFriends = {
            let str = "Скачай Me2\n Доступно бесплатно в:\n App store: www.me2.kz \n Google play: www.me2.kz"
            
            let activityViewController = UIActivityViewController(activityItems: [str], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.parentVC.view
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop]
            
            self.parentVC.present(activityViewController, animated: true, completion: nil)
        }
        
        synchronizeContacts = {
            let numbers = self.getContactsPhoneNumbers()
            self.getUsers(with: numbers)
        }
        
        actions = [inviteFriends, synchronizeContacts]
    }
    
    func contactForCell(at indexPath: IndexPath) -> ContactUser {
        let section = sections[indexPath.section]
        
        switch section {
        case .searchResults:
            return searchResults[indexPath.row]
        case .synchronizedContacts:
            return synchronizedUsers[indexPath.row]
        default:
            return ContactUser(json: JSON())
        }
    }
    
    func searchUser(by username: String, completion: ResponseBlock?) {
        let url = Network.user + "/?search=\(username)"
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        Alamofire.request(encodedUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    self.searchResults = []
                    for item in json["data"]["results"].arrayValue {
                        self.searchResults.append(ContactUser(json: item))
                    }
                    
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(.fail, "")
                }
        }
    }
    
    func addToContactsUser(withID id: Int, completion: ResponseBlock?) {
        let url = Network.contact + "/"
        let params = ["user2": id] as [String: Any]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    if json["code"].intValue == 0 {
                        self.myContacts.value.append(Contact(json: json))
                        completion?(.ok, "")
                    } else {
                        self.contactUsers.removeAll(where: { $0.id == id })
                        completion?(.error, "")
                    }
                    
                case .failure( _):
                    print(JSON(response.data as Any))
                    self.contactUsers.removeAll(where: { $0.id == id })
                    completion?(.fail, "")
                }
        }
    }
    
    private func getUsers(with numbers: [String]) {
        let url = Network.user + "/sync/"
        let editedNumbers = editedPhoneNumbers(from: numbers)
        let params: [String: Any] = ["phones": editedNumbers]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    self.synchronizedUsers = []
                    for item in json["data"].arrayValue {
                        self.synchronizedUsers.append(ContactUser(json: item))
                    }
                    
                    self.contactsSynchronized.value = true
                    
                case .failure( _):
                    print(JSON(response.data as Any))
                }
        }
    }
}

extension AddContactViewModel {
    private func getContactsPhoneNumbers() -> [String] {
        var phoneNumbers = [String]()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        let contactStore = CNContactStore()
        
        do {
            try contactStore.enumerateContacts(with: request) {
                (contact, stop) in
                
                contact.phoneNumbers.forEach { (phone) in
                    phoneNumbers.append(phone.value.stringValue)
                }
            }
        }
        catch {
            print("unable to fetch contacts")
        }
        
        return phoneNumbers
    }
    
    private func editedPhoneNumbers(from numbers: [String]) -> [String] {
        var editedNumbers = [String]()
        
        numbers.forEach({ editedNumbers.append(convertPhone(from: $0)) })
        
        return editedNumbers
    }
    
    private func convertPhone(from phone: String) -> String {
        var convertedPhone = phone
        if convertedPhone.first == "8" {
            convertedPhone.removeFirst()
            convertedPhone = "+7" + convertedPhone
        }
        
        let pattern = "+###########"
        convertedPhone = convertedPhone.applyPatternOnNumbers(pattern: pattern, replacmentCharacter: "#")
        
        return convertedPhone
    }
}
