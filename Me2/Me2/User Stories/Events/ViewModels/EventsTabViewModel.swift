//
//  EventsTabViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/15/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class EventsTabViewModel {
    var allEvents = [Event]()
    
    func getAllEvents(completion: ResponseBlock?) {
        Alamofire.request(eventsURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    self.allEvents = []
                    for item in json["data"]["results"].arrayValue {
                        self.allEvents.append(Event(json: item))
                    }
                    
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(JSON(error))
                    completion?(.fail, "")
                }
        }
    }
    
    let eventsURL = Network.core + "/event/"
}
