//
//  EventsSearchViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/25/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class EventsSearchViewModel {
    let searchValue: Dynamic<String>
    let updateSearchResults: Dynamic<Bool>
    var lastSearchVaue = String()
    var searchResults = [Event]()
    var tagIDsToSearch: Dynamic<[Int]>!
    
    init(searchValue: Dynamic<String>, tagIDsToSearch: Dynamic<[Int]>) {
        self.searchValue = searchValue
        self.tagIDsToSearch = tagIDsToSearch
        self.updateSearchResults = Dynamic(false)
        
        bindDynamics()
    }
    
    private func bindDynamics() {
        self.searchValue.bind { [unowned self] (value) in
            if value != "" {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    if self.searchValue.value == value {
                        self.searchEvents(by: value)
                    }
                    
                    self.lastSearchVaue = value
                })
                
            } else {
                
                self.searchResults = []
                self.updateSearchResults.value = true
                
            }
        }
        
        self.tagIDsToSearch.bind { [weak self] (tagIDs) in
            if self?.searchValue.value == "" && (self?.tagIDsToSearch.value.count)! == 0 {
                self?.searchResults = []
                self?.updateSearchResults.value = true
            } else {
                self?.searchEvents(by: self?.searchValue.value ?? "")
            }
        }
    }
    
    private func searchEvents(by subStr: String) {
        let url = searchEventsURL + "\(subStr)" + "&tag_ids=\(tagIDsToString())"
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        Alamofire.request(encodedUrl, method: .get, parameters: nil, encoding: JSONEncoding.prettyPrinted, headers: Network.getHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    self.searchResults = []
                    for item in json["data"]["results"].arrayValue {
                        self.searchResults.append(Event(json: item))
                    }
                    
                    self.updateSearchResults.value = true
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self.updateSearchResults.value = true
                }
        }
    }
    
    private func tagIDsToString() -> String {
        var str = ""
        for tagID in tagIDsToSearch.value {
            str += "\(tagID),"
        }
        
        return str
    }
    
    let searchEventsURL = Network.core + "/event/?search="
}
