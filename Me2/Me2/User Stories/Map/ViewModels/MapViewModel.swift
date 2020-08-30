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
    var myLocation = CLLocation() {
        didSet {
            Location.my = self.myLocation
        }
    }
    var placePins = [PlacePin]()
    var places = [Place]()
    
    var updatedPlaces = [JSON]()
    
    var currentPlaceCardIndex = Dynamic(0)
    var currentLiveRoomUUID = ""
    
    func getPlacePins(completion: ((RequestStatus, String) -> ())?) {
        getPlacePinsFromDB(completion: completion)

        guard shouldUpdateDB() else { return }

        let url = placesURL + "?limit=500"
        getPlaces(at: url, completion: completion)
    }
    private func getPlaces(at url: String, completion: ResponseBlock?) {
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getHeaders())
            .responseJSON { [weak self] (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    for item in json["data"]["results"].arrayValue {
                        self?.updatedPlaces.append(item)
                    }
                    
                    let nextUrl = json["data"]["next"].stringValue
                    if nextUrl == "" {
                        self?.updateDB()
                        completion?(.ok, "")
                    } else {
                        self?.getPlaces(at: nextUrl, completion: completion)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(.fail, "")
                }
        }
    }
    
    private func getPlacePinsFromDB(completion: ResponseBlock?) {
        let placePinDAOs = RealmAdapter.shared.objects(PlacePinDAO.self)
        
        for item in placePinDAOs {
            placePins.append(item.place())
        }
        
        if placePins.count > 0 {
            completion?(.ok, "")
        }
    }
    
    private func updateDB() {
        let allPlacePins = RealmAdapter.shared.objects(PlacePinDAO.self)
        try! RealmAdapter.shared.write {
            RealmAdapter.shared.delete(allPlacePins)
        }
        
        placePins = []
        
        for item in updatedPlaces {
            let placePin = PlacePin.convert(from: item)
            self.placePins.append(placePin)
            RealmAdapter.write(object: PlacePinDAO.object(fromPlace: placePin))
        }
        
        updateDBDate()
    }
    
    private func updateDBDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        let date = Date()
        
        UserDefaults().set(dateFormatter.string(from: date), forKey: UserDefaultKeys.lastDbUpdate.rawValue)
    }
    
    private func shouldUpdateDB() -> Bool {
        guard  let prevUpdatedDate = UserDefaults().object(forKey: UserDefaultKeys.lastDbUpdate.rawValue) as? String else { return true }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        let date = Date()
        let prevDate = dateFormatter.date(from: prevUpdatedDate)
        
        let components = Calendar.current.dateComponents([.hour], from: prevDate!, to: date)
        let diff = components.hour!
        
        return diff > 24
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
                    
                    if json["code"].intValue == 0 {
                        UserDefaults().set(uuid, forKey: UserDefaultKeys.enteredRoom.rawValue)
                    }
                    
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
                    
                    if json["code"].intValue == 0 {
                        UserDefaults().removeObject(forKey: UserDefaultKeys.enteredRoom.rawValue)
                    }
                    
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
