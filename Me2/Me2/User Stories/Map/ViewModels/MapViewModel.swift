//
//  MapViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/13/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON
import GoogleMaps
import RealmSwift

enum ImhereIcon: String {
    case plain = "map_marker_icon"
    case active = "active_map_marker_icon"
    case inactive = "inactive_map_marker_icon"
}

class MapViewModel {
    var isMyLocationVisible: Dynamic<Bool> = Dynamic(false)
    var myLocation = CLLocation()
    var placePins = [PlacePin]()
    var places = [Place]()
    
    var currentPlaceCardIndex = Dynamic(0)
    var currentLiveRoomUUID = ""
    
    func getPlacePins(completion: ((RequestStatus, String) -> ())?) {
        Alamofire.request(placesURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getHeaders())
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
    
    func getPlacesInRadius(completion: ResponseBlock?) {
        let idList = getPlacesInRadiusAsString()
        if idList == "" {
            places = []
            completion?(.ok, "")
            
            return 
        }
        
        getPlaces(idList: getPlacesInRadiusAsString(), completion: completion)
    }
    
    func getPlaceCardInfo(with id: Int, completion: ResponseBlock?) {
        getPlaces(idList: "\(id)", completion: completion)
    }
    
    private func getPlaces(idList: String, completion: ResponseBlock?) {
        let url = placesURL + "?id_list=\(idList)"
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        Alamofire.request(encodedUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getHeaders())
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    self.places = []
                    for item in json["data"]["results"].arrayValue {
                        let place = Place(json: item)
                        self.places.append(place)
                    }
                    
                    self.sortPlacesByDistance()
                    
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(.fail, "")
                }
        }
    }
    
    func enterNewRoom(at index: Int) {
        let prevLiveRoomUUID = currentLiveRoomUUID
        currentLiveRoomUUID = places[index].roomInfo?.uuid ?? ""
        
        exitLiveRoom(with: prevLiveRoomUUID)
        enterLiveRoom(with: currentLiveRoomUUID)
    }
    
    func exitAllRooms() {
        exitLiveRoom(with: currentLiveRoomUUID)
        
        currentLiveRoomUUID = ""
    }
    
    private func enterLiveRoom(with uuid: String) {
        let url = roomURL + "\(uuid)/enter/"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders())
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    private func exitLiveRoom(with uuid: String) {
        let url = roomURL + "\(uuid)/exit/"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders())
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    private func getPlacesInRadiusAsString() -> String {
        var str = ""
        
        for place in placePins {
            let location = CLLocation(latitude: place.latitude, longitude: place.longitude)
            if myLocation.distance(from: location) <= 200 {
                str += "\(place.id ?? 0),"
            }
        }
        
        if str != "" { str.removeLast() }
        return str
    }
    
    private func sortPlacesByDistance() {
        for place in places {
            let location = CLLocation(latitude: place.latitude, longitude: place.longitute)
            place.distance = myLocation.distance(from: location)
        }
        
        places.sort(by: { $0.distance! < $1.distance! })
    }
    
    private let placesURL = Network.core + "/place/"
    private let roomURL = Network.chat + "/room/"
    
    let radius: CLLocationDistance = 200
}
