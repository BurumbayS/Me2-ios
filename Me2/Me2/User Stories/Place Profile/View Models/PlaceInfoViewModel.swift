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

}
