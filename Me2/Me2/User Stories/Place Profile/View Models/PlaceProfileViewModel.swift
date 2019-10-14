//
//  PlaceProfileViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/23/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum PlaceProfilePage: String  {
    case info = "PlaceInfoCell"
    case events = "PlaceEventsCell"
    case menu = "PlaceMenuCell"
    case reviews = "PlaceReviewsCell"
    
    var cellID: String {
        return self.rawValue
    }
    
    func getCellClass() -> UICollectionViewCell.Type {
        switch self {
        case .info:
            return PlaceInfoCollectionViewCell.self
        case .menu:
            return PlaceMenuCollectionViewCell.self
        case .reviews:
            return PlaceReviewsCollectionViewCell.self
        case .events:
            return PlaceEventsCollectionViewCell.self
        }
    }
}

class PlaceProfileViewModel {
    var currentPage: Dynamic<Int>
    var pageToShow: Dynamic<PlaceProfilePage>
    var placeStatus: PlaceStatus
    var place: Place
    
    var dataLoaded = false
    
    init(place: Place) {
        self.place = place
        pageToShow = Dynamic(.info)
        currentPage = Dynamic(0)
        placeStatus = .registered//place.regStatus
        
        currentPage.bind { [unowned self] (index) in
            self.pageToShow.value = self.place.regStatus.pages[index]
        }
    }
    
    func fetchData(completion: ResponseBlock?) {
        if dataLoaded { return }
        
        let url = placeInfoURL + "\(place.id ?? 0)/"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getHeaders())
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    self.place = Place(json: json["data"])
                    
                    self.dataLoaded = true
                    
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(.fail, "")
                }
        }
    }
    
    func numberOfSections() -> Int {
        return (dataLoaded) ? 2 : 0
    }
    
    private let placeInfoURL = Network.core + "/place/"
}
