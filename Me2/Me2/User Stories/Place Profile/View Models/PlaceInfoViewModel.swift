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
    
    func configure(placeID: Int, placeStatus: PlaceStatus) {
        self.placeID = placeID
        self.placeStatus = placeStatus
    }
    
    func fetchData(completion: ResponseBlock?) {
        if dataLoaded { return }
        
        let url = placeInfoURL + "\(placeID ?? 0)/"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getHeaders())
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    self.placeInfo = Place(json: json["data"])
                    
                    self.dataLoaded = true
                    self.configureSections()
                    
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(.fail, "")
                }
        }
    }
    
    private func configureSections() {
        switch placeStatus {
        case .registered?:
            placeSections = [.description, .contactUs, .address, .workTime, .mail, .site, .tags, .subsidiaries]
        case .not_registered?:
            placeSections = [.address, .workTime, .mail, .site, .subsidiaries]
        default:
            break
        }
    }
    
    private let placeInfoURL = Network.core + "/place/"
}
