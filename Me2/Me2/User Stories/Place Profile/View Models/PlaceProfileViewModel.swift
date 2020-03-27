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
    var placeJSON: JSON!
    
    var dataLoaded = false
    
    var isFollowed: Dynamic<Bool> = Dynamic(false)
    
    init(place: Place) {
        self.place = place
        pageToShow = Dynamic(.info)
        currentPage = Dynamic(0)
        placeStatus = place.regStatus
        
        currentPage.bind { [unowned self] (index) in
            self.pageToShow.value = self.place.regStatus.pages[index]
        }
    }
    
    func fetchData(completion: ResponseBlock?) {
        if dataLoaded { return }
        
        let url = placeInfoURL + "\(place.id ?? 0)/"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders())
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    self.placeJSON = json["data"]
                    self.place = Place(json: json["data"])
                    
                    self.getSubsidiaries(completion: completion)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(.fail, "")
                }
        }
    }
    
    private func getSubsidiaries(completion: ResponseBlock?) {
        let url = placeInfoURL + "?branch=\(place.branch)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders())
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    var subsidiaries = [Place]()
                    for item in json["data"]["results"].arrayValue {
                        subsidiaries.append(Place(json: item))
                    }
                    
                    self.place.subsidiaries = subsidiaries
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
    
    func followPlace() {
        isFollowed.value = !isFollowed.value
        
        followPressed(status: isFollowed.value) { [weak self] (status, message) in
            switch status {
            case .ok:
                break
            default:
                self?.isFollowed.value = !(self?.isFollowed.value)!
            }
        }
    }
    
    private func followPressed(status: Bool, completion: ResponseBlock?) {
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
    
    private let placeInfoURL = Network.core + "/place/"
}
