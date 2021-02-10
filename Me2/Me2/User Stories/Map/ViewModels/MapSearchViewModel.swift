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
    var filterData: Dynamic<[FilterData]>
    
    init(searchValue: Dynamic<String>) {
        self.searchValue = searchValue
        self.updateSearchResults = Dynamic(false)
        self.filterData = Dynamic([])
        self.lastSearchResults = UserDefaults().object(forKey: UserDefaultKeys.lastMapSearchResults.rawValue) as? [String] ?? []
        
        bindDynamics()
    }
    
    private func bindDynamics() {
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
        
        self.filterData.bind { [unowned self] (filters) in
            self.searchPlace(by:  self.searchValue.value)
        }
    }
    
    func addToLastSearchResults(result: String) {
        if lastSearchResults.count > 5 { lastSearchResults.removeFirst() }
        
        lastSearchResults.append(result)
        UserDefaults().set(lastSearchResults, forKey: UserDefaultKeys.lastMapSearchResults.rawValue)
    }
    
    private func searchPlace(by searchValue: String) {
        let url = placesURL + "?search=\(searchValue)" + filtersToString()
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        Alamofire.request(encodedUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getHeaders())
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
    
    private func filtersToString() -> String {
        var str = ""
        
        for item in filterData.value {
            str += "&\(item.key)="
            
            if item.key == "tag_ids" { str += toString(array: item.value as! [Int]) }
            else { str += "\(item.value)" }
        }
        
        return str
    }
    
    private func toString(array: [Int]) -> String{
        var str = ""
        
        for item in array {
            str += "\(item),"
        }
        
        if str != "" { str.removeLast() }
        
        return str
    }
    
    private let placesURL = Network.core + "/place/"
}
