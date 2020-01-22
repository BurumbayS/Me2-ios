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
    var categoriesToShow = [EventCategoriesType]()
    var categories = [EventCategoriesType.saved, .popular, .new_places, .favourite_places, .actual]
    var categoryViewModels = [CategoryEventsListViewModel]()
    let newPlacesViewModel = NewPlacesViewModel()
    var allEvents = [Event]()
    var savedEvents = [Event]()
    var listType: Dynamic<EventsListType>
    var tagIDsToSearch: Dynamic<[Int]>
    
    init() {
        listType = Dynamic(.ByCategories)
        tagIDsToSearch = Dynamic([])
        
        bindDynamics()
        configureCategories()
        loadSavedEvents()
    }
    
    private func bindDynamics() {
        listType.bind { [weak self] (value) in
            switch value {
            case .ByCategories:
                self?.categoriesToShow = self!.categories
            case .AllInOne:
                self?.categoriesToShow = [.saved, .all]
            }
        }
    }
    
    private func configureCategories() {
        categories = [.saved, .popular, .new_places, .favourite_places, .actual]
        categoriesToShow = categories
        for category in categories {
            categoryViewModels.append(CategoryEventsListViewModel(categoryType: category))
        }
    }
    
    private func loadSavedEvents() {
        if let userInfoString = UserDefaults().object(forKey: UserDefaultKeys.userInfo.rawValue) as? String {
            let json = JSON(parseJSON: userInfoString)
            
            savedEvents = []
            for item in json["data"]["user"]["favourite_events"].arrayValue {
                savedEvents.append(Event(json: item))
            }
        }
    }
    
    func getAllEvents(completion: ResponseBlock?) {
        Alamofire.request(eventsURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
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
