//
//  PlaceReviewsViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/14/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class PlaceReviewsViewModel {
    var placeID = 0
    var reviews = [Review]()
    
    var dataLoaded = false
    
    func configure(placeID: Int) {
        self.placeID = placeID
    }
    
    func fetchData(completion: ResponseBlock?) {
        if dataLoaded { completion?(.ok, "") }
        
        let url = reviewsURL + "?place=\(placeID)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    self.reviews = []
                    for item in json["data"]["results"].arrayValue {
                        self.reviews.append(Review(json: item))
                    }
                    
                    self.dataLoaded = true
                    
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(.fail, "")
                }
        }
    }
    
    let reviewsURL = Network.core + "/review/"
}
