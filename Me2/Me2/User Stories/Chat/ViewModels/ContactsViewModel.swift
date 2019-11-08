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
    var searchResults = [User]()
    var lastSearchResults = [String]()
    let contactSelectionHandler: ((Int) -> ())?
    
    var searchActivated = false
    
    init(onContactSelected: ((Int) -> ())?) {
        self.contactSelectionHandler = onContactSelected
        self.updateSearchResults = Dynamic(false)
    }
    
    func bindDynamics() {
        self.searchValue.bind { [unowned self] (value) in
            if value != "" {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    if self.searchValue.value == value {
                        self.searchUser(by: value)
                    }
                    
                    self.lastSearchVaue = value
                })
                
            } else {
                
                self.searchResults = []
                self.updateSearchResults.value = true
                
            }
        }
    }
    
    private func searchUser(by str: String) {
        let url = Network.user + "/?search=\(searchValue.value)"
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        Alamofire.request(encodedUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    self.searchResults = []
                    for item in json["data"]["results"].arrayValue {
                        self.searchResults.append(User(json: item))
                    }
                    
                    self.updateSearchResults.value = true
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self.updateSearchResults.value = true
                }
        }
    }
}
