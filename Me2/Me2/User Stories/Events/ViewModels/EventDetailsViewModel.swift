//
//  EventDetailsViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/17/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

enum EventDetailsSection {
    case header
    case description
    case tags
    case placeLink
    case adress
}

class EventDetailsViewModel {
    let eventID: Int
    var event: Event!
    var eventJSON: JSON!
    var sections = [EventDetailsSection]()
    
    init(eventID: Int) {
        self.eventID = eventID
    }
    
    func fetchData(completion: ResponseBlock?) {
        let url = eventDetailsURL + "\(eventID)/"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    self.eventJSON = json["data"]
                    self.event = Event(json: json["data"])
                    
                    self.configureSections(completion: completion)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(.fail, "")
                }
        }
    }
    
    private func configureSections(completion: ResponseBlock?) {
        sections.append(.header)
        sections.append(.description)
        if (event.tags.count > 0) { sections.append(.tags) }
        sections.append(.placeLink)
        sections.append(.adress)
        
        completion?(.ok, "")
    }
    
    let eventDetailsURL = Network.core + "/event/"
}
