//
//  FavouritePlacesViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/16/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class FavouritePlacesViewModel {

    let isEditable: Bool
    var favouritePlaces: Dynamic<[Place]>!
    var places = [Place]()
    var toDeletePlaceIndexPath: IndexPath?
    
    init(places: Dynamic<[Place]>, isEditable: Bool) {
        self.favouritePlaces = places
        self.places = places.value
        self.isEditable = isEditable
    }
    
    func removeFromFavourite(place: Place, completion: ResponseBlock?) {
        let url = Network.core + "/place/\(place.id ?? 0)/remove_favourite/"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error)
                    completion?(.fail, "")
                }
        }
    }
}
