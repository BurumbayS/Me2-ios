//
//  EventDetailsViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/17/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class EventDetailsViewModel {
    let eventID: Int
    var event: Event!
    
    init(eventID: Int) {
        self.eventID = eventID
    }
    
    func fetchData(completion: ResponseBlock?) {
        let url = eventDetailsURL + "\(eventID)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    self.event = Event(json: json["data"])
                    
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(.fail, "")
                }
        }
    }
    
    let eventDetailsURL = Network.core + "/event/"
}
