//
//  ListOfAllViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/25/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

enum ListItemType {
    case event
    case place
}

class ListOfAllViewModel {
    let listItemType: ListItemType
    let category: EventCategoriesType
    var eventsList = [Event]()
    var placesList = [Place]()
    
    init(category: EventCategoriesType, eventsList: [Event] = []) {
        self.category = category
        self.eventsList = eventsList
        
        if category == .new_places {
            listItemType = .place
        } else {
            listItemType = .event
        }
    }
    
    func fetchData(completion: ResponseBlock?) {
        if category == .saved {
            completion?(.ok, "")
            return
        }
        
        switch listItemType {
        case .event:
            getEvents(completion: completion)
        case .place:
            getPlaces(completion: completion)
        }
    }
    
    func getNumberOfItems() -> Int {
        switch listItemType {
        case .place:
            return placesList.count
        case .event:
            return eventsList.count
        }
    }
    
    private func getPlaces(completion: ResponseBlock?) {
        Alamofire.request(newPlacesListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    self.placesList = []
                    for item in json["data"]["results"].arrayValue {
                        self.placesList.append(Place(json: item))
                    }
                    
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error)
                    completion?(.fail, "")
                }
        }
    }
    
    private func getEvents(completion: ResponseBlock?) {
        let url = eventsListURL + "?type=\(category.rawValue)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    self.eventsList = []
                    for item in json["data"]["results"].arrayValue {
                        self.eventsList.append(Event(json: item))
                    }
                    
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(.fail, "")
                }
        }
    }
    
    let eventsListURL = Network.core + "/event/"
    let newPlacesListURL = Network.core + "/place/?ordering=-created_at"
}
