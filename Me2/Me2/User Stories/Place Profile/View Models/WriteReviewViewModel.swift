//
//  WriteReviewViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/14/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class WriteReviewViewModel {
    let placeID: Int
    
    init(placeID: Int) {
        self.placeID = placeID
    }
    
    func writeReview(with text: String, and rating: Double, completion: ResponseBlock?) {
        let params = ["place": placeID,
                      "body": text,
                      "rating": rating] as [String : Any]
        
        Alamofire.request(createReviewURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error)
                    completion?(.error, "")
                }
        }
    }
    
    let createReviewURL = Network.core + "/review/"
}
