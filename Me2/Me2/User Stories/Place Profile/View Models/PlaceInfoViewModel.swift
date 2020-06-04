//
//  PlaceInfoViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/2/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

enum PlaceInfoSection {
    case description
    case contactUs
    case address
    case workTime
    case mail
    case site
    case tags
    case subsidiaries
}

class PlaceInfoViewModel {
    var placeSections = [PlaceInfoSection]()
    var placeInfo: Place!
    var placeID: Int!
    var placeStatus: PlaceStatus!
    
    var dataLoaded = false
    
    init(place: Place) {
        self.placeInfo = place
        
        configureSections()
    }
    
    private func configureSections() {
        switch placeInfo.regStatus {
        case .registered?:
            placeSections = [.description, .contactUs, .address, .workTime, .mail, .site, .tags]
        case .not_registered?:
            placeSections = [.address, .workTime, .mail, .site]
        default:
            break
        }
        
        if let subs = placeInfo.subsidiaries, subs.count > 0 {
            placeSections.append(.subsidiaries)
        }
    }
    
    func writeToPlaceAdmin(completion: ((Room?, String) -> ())?) {
        let url = Network.chat + "/room/service_room/"
        let params = ["place": placeInfo.id!]
        
        Alamofire.request(url, method: .post, parameters: params as Parameters, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    
                    if json["code"].intValue == 0 {
                        let room = Room(json: json["data"])
                        completion?(room, "")
                    } else {
                        completion?(nil, json["message"].stringValue)
                    }
                    
                case .failure(_):
                    print(JSON(response.data as Any))
                    completion?(nil, "")
                }
        }
    }

}
