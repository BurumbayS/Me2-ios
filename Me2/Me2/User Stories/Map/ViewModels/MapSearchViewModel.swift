//
//  MapSearchViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/13/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class MapSearchViewModel {
    let searchValue: Dynamic<String>
    var lastSearchVaue = String()
    var searchResults = [Place]()
    var lastSearchResults = [String]()
    let updateSearchResults: Dynamic<Bool>
    
    init(searchValue: Dynamic<String>) {
        self.searchValue = searchValue
        self.updateSearchResults = Dynamic(false)
        self.lastSearchResults = UserDefaults().object(forKey: "lastMapSearchResults") as! [String]
        
        self.searchValue.bind { [unowned self] (value) in
            if value != "" {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    if self.searchValue.value == value {
                        self.searchPlace(by: value)
                    }
                    
                    self.lastSearchVaue = value
                })
                
            } else {
                
                self.searchResults = []
                self.updateSearchResults.value = true
                
            }
        }
    }
    
    private func searchPlace(by searchValue: String) {
        let url = placesURL + "?search=\(searchValue)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getHeaders())
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    self.searchResults = []
                    for item in json["data"]["results"].arrayValue {
                        let place = Place(json: item)
                        self.searchResults.append(place)
                    }
                    
                    self.updateSearchResults.value = true
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self.updateSearchResults.value = true
                }
        }
    }
    
    private let placesURL = Network.core + "/place/"
}
