//
//  NewPlacesViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/16/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class NewPlacesViewModel {
    var places = [Place]()
    
    var dataLoaded = false
    
    func fetchData(completion: ResponseBlock?) {
        if dataLoaded {
            completion?(.ok, "")
            return
        }
        
        Alamofire.request(getNewPlacesURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    self.places = json["data"]["results"].arrayValue.compactMap({Place(json: $0)})
                    
                    self.dataLoaded = true
                    
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error)
                    completion?(.fail, "")
                }
        }
    }
    
    let getNewPlacesURL = Network.core + "/place/?limit=5&ordering=-created_at"
}
