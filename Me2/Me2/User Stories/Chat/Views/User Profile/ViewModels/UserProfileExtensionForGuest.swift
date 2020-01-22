//
//  UserProfileExtensionForGuest.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/13/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

//Extension for methods for guest profile
extension UserProfileViewModel {
    
    func getChatWithUser(completion: ResponseBlock?) {
        let params = ["room_type": "SIMPLE", "participants": [userInfo.value.id]] as [String: Any]
        let url = Network.chat + "/room/"
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    self.chatRoom = Room(json: json["data"])
                    
                    completion?(.ok, "")
                    
                case .failure(_ ):
                    print(JSON(response.data as Any))
                    completion?(.fail, "")
                }
        }
    }
    
    private func removeFromContacts() {
        guard let id = userInfo.value.contact?.id else { return }
        
        let url = Network.contact + "/\(id)/"
        
        Alamofire.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    
                case .failure( _):
                    print(JSON(response.data as Any))
                }
        }
    }
    
    private func addToContacts() {
        let url = Network.contact + "/"
        let params = ["user2": userInfo.value.id] as [String: Any]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    
                case .failure( _):
                    print(JSON(response.data as Any))
                }
        }
    }
    
    func selectedGuestProfileCell(at indexPath: IndexPath) {
        switch guestProfileCells[indexPath.row] {
        case .addContact:
            guestProfileCells = [.removeContact]
            parentVC.tableView.reloadData()
            
            addToContacts()
        case .removeContact:
            guestProfileCells = [.addContact]
            parentVC.tableView.reloadData()
            
            removeFromContacts()
        }
    }
}
