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
    var categories = [EventCategoriesType]()
    var categoryViewModels = [CategoryEventsListViewModel]()
    let newPlacesViewModel = NewPlacesViewModel()
    var allEvents = [Event]()
    var listType: Dynamic<EventsListType>
    
    init() {
        listType = Dynamic(.ByCategories)
        listType.bind { [weak self] (value) in
            switch value {
            case .ByCategories:
                self?.categories = [.saved, .popular, .new_places, .favourite, .actual]
            case .AllInOne:
                self?.categories = [.saved, .all]
            }
        }
        
        categories = [.saved, .popular, .new_places, .favourite, .actual]
        for category in categories {
            categoryViewModels.append(CategoryEventsListViewModel(categoryType: category))
        }
    }
    
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
