//
//  CategoryEventsListViewMode.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/16/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class CategoryEventsListViewModel {
    let categoryType: EventCategoriesType
    var eventsList = [Event]()
    
    var dataLoaded = false
    
    init(categoryType: EventCategoriesType) {
        self.categoryType = categoryType
    }
    
    func fetchData(completion: ResponseBlock?) {
        if dataLoaded {
            completion?(.ok, "")
            return
        }
        
        let url = eventsListURL + "?limit=5&type=\(categoryType.rawValue)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    self.eventsList = []
                    for item in json["data"]["results"].arrayValue {
                        self.eventsList.append(Event(json: item))
                    }
                    
                    self.dataLoaded = true
                    
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(.fail, "")
                }
        }
    }
    
    let eventsListURL = Network.core + "/event/"
}
