//
//  AddFavouritePlaceViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/16/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class AddFavouritePlaceViewModel {
    var currentFavouritePlaces: [Place]
    var addPlacehandler: ((Place) -> ())?
    var searchResults = [Place]()
    let searchValue: Dynamic<String>
    let updateSearchResults: Dynamic<Bool>
    
    init(favouritePlaces: [Place], onAddPlace: ((Place) -> ())?) {
        self.currentFavouritePlaces = favouritePlaces
        self.addPlacehandler = onAddPlace
        
        self.updateSearchResults = Dynamic(false)
        self.searchValue = Dynamic("")
        
        bindDynamics()
    }
    
    private func bindDynamics() {
        self.searchValue.bind { [unowned self] (value) in
            if value != "" {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    if self.searchValue.value == value {
                        self.searchPlace(by: value)
                    }
                })
                
            } else {
                
                self.searchResults = []
                self.updateSearchResults.value = true
                
            }
        }
    }
    
    private func searchPlace(by searchValue: String) {
        let url = placesURL + "?search=\(searchValue)"
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        Alamofire.request(encodedUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getHeaders())
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    self.searchResults = json["data"]["results"].arrayValue.compactMap({Place(json: $0)})
                    
                    self.updateSearchResults.value = true
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    func addPlaceToFavourite(with id: Int, completion: ResponseBlock?) {
        let url = placesURL + "\(id)/add_favourite/"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders())
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    let code = json["code"].intValue
                    
                    switch code {
                    case 0:
                        completion?(.ok, "")
                    default:
                        completion?(.error, json["message"].stringValue)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(.fail, "")
                }
        }
    }
    
     private let placesURL = Network.core + "/place/"
}
