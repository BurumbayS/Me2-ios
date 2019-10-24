//
//  PlaceEventsViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/14/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class PlaceEventsViewModel {
    var placeID: Int = 0
    var events = [Event]()
    
    var dataLoaded = false
    
    func configure(placeID: Int) {
        self.placeID = placeID
    }
    
    func fetchData(completion: ResponseBlock?) {
        if dataLoaded { completion?(.ok, "") }
        
        let url = eventURL + "?place=\(placeID)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    self.events = []
                    for item in json["data"]["results"].arrayValue {
                        self.events.append(Event(json: item))
                    }
                    
                    self.dataLoaded = true
                    
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(.fail, "")
                }
        }
    }
    
    let eventURL = Network.core + "/event/"
}
