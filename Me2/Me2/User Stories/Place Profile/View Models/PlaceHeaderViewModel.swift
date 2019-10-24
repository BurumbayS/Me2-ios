//
//  PlaceHeaderViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/22/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class PlaceHeaderViewModel {
    let place: Place
    
    init(place: Place) {
        self.place = place
    }
    
    func followPressed(status: Bool, completion: ResponseBlock?) {
        status ? addToFavourite(completion: completion) : removeFromFavourite(completion: completion)
    }
    
    private func addToFavourite(completion: ResponseBlock?) {
        let url = Network.core + "/place/\(place.id ?? 0)/add_favourite/"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success( _):
                    
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error)
                    completion?(.fail, "")
                }
        }
    }
    
    private func removeFromFavourite(completion: ResponseBlock?) {
        let url = Network.core + "/place/\(place.id ?? 0)/remove_favourite/"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success( _):
                    
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error)
                    completion?(.fail, "")
                }
        }
    }
}
