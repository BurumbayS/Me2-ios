//
//  PlaceInfoViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/2/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

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
    
    init(placeStatus: PlaceStatus) {
        switch placeStatus {
        case .registered:
            placeSections = [.description, .contactUs, .address, .workTime, .mail, .site, .tags, .subsidiaries]
        case .not_registered:
            placeSections = [.address, .workTime, .mail, .site, .subsidiaries]
        }
    }
}
