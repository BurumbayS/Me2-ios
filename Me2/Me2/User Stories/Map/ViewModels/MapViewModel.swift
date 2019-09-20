//
//  MapViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/13/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

enum ImhereIcon: String {
    case plain = "map_marker_icon"
    case active = "active_map_marker_icon"
    case inactive = "inactive_map_marker_icon"
}

class MapViewModel {
    var isMyLocationVisible: Dynamic<Bool> = Dynamic(false)
    var placePins = [PlacePin]()
    
    func getPlacePins(completion: ((RequestStatus, String) -> ())?) {
        Alamofire.request(placesPinsURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getHeaders())
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    for item in json["data"]["results"].arrayValue {
                        self.placePins.append(PlacePin.convert(from: item))
                    }
                    
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(.fail, "")
                }
        }
    }
    
    private let placesPinsURL = Network.core + "/place/"
}
