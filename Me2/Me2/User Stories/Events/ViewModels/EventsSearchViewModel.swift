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
    
    init(searchValue: Dynamic<String>) {
        self.searchValue = searchValue
        self.updateSearchResults = Dynamic(false)
        
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
    }
    
    private func searchEvents(by subStr: String) {
        let url = searchEventsURL + "\(subStr)"
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
    
    let searchEventsURL = Network.core + "/event/?search="
}
