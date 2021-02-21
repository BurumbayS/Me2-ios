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

    var places: [Place]
    var placePins: [PlacePin]
    var updatedPlaces: [JSON]
    let error: Dynamic<String?>
    var currentLiveRoomUUID: String
    var isMyLocationVisible: Dynamic<Bool>
    var currentPlaceCardIndex: Dynamic<Int>
    private let locationManager: LocationManagerInterface

    public var locationManagerError: String? {
        self.locationManager.statusObservable.value.errorReason
    }

    init(places: [Place] = [],
         updatedPlaces: [JSON] = [],
         placePins: [PlacePin] = [],
         currentLiveRoomUUID: String = "",
         error: Dynamic<String?> = Dynamic.init(nil),
         currentPlaceCardIndex: Dynamic<Int> = Dynamic(0),
         isMyLocationVisible: Dynamic<Bool> = Dynamic(false),
         locationManager: LocationManagerInterface = AppLocationManager()) {

        self.error = error
        self.places = places
        self.placePins = placePins
        self.updatedPlaces = updatedPlaces
        self.locationManager = locationManager
        self.isMyLocationVisible = isMyLocationVisible
        self.currentLiveRoomUUID = currentLiveRoomUUID
        self.currentPlaceCardIndex = currentPlaceCardIndex
        self.viewDidLoad()
    }

    var clLocationCoordinate2D: CLLocationCoordinate2D {
        return self.locationManager.locationCoordinate2D()
    }

    func getPlacePins(completion: ((RequestStatus, String) -> ())?) {
        getPlacePinsFromDB(completion: completion)

        guard shouldUpdateDB() else {
            return
        }

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

    func viewDidLoad() {
        self.locationManager.statusObservable.bind { [weak self] status in
            switch status {
            case .notDetermined:
                break
            case .restricted:
                break
            case .denied:
                self?.error.value = status.errorReason
            case .authorizedAlways:
                break
            case .authorizedWhenInUse:
                break
            @unknown default:
                self?.error.value = status.errorReason
            }
        }

        self.locationManager.locationObservable.bind { location in
            Location.my = location
        }
        self.locationManager.startMonitoring()
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
        guard let uuid = places[index].roomInfo?.uuid, !uuid.isEmpty else {
            return
        }
        let prevLiveRoomUUID = currentLiveRoomUUID
        currentLiveRoomUUID =  uuid
        
        exitLiveRoom(with: prevLiveRoomUUID)
        enterLiveRoom(with: currentLiveRoomUUID)
    }
    
    func exitAllRooms() {
        guard !self.currentLiveRoomUUID.isEmpty else {
            return
        }
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
        return self.placePins.filter { [weak self] place in
                    self?.locationManager.distance(to: .init(latitude: place.latitude, longitude: place.longitude)) ?? 0 <= 200
                }
                .compactMap({ $0.id?.description })
                .joined(separator: ",")
    }
    
    private func sortPlacesByDistance() {
        for place in places {
            let location = CLLocation(latitude: place.latitude, longitude: place.longitute)
            place.distance = self.locationManager.distance(to: location)
        }
        places.sort(by: { $0.distance! < $1.distance! })
    }
    
    private let placesURL = Network.core + "/place/"
    private let roomURL = Network.chat + "/room/"
    
    let radius: CLLocationDistance = 200
}


extension CLAuthorizationStatus {
    var errorReason: String? {
        switch self {

        case .notDetermined:
            return "Пожалуйста, откройте настройки и разрешите Me2 использовать ваше местонахождение"
//            return "Пользователь еще не сделал выбор в отношении этого приложения".localized
        case .restricted:
            return "Пожалуйста, откройте настройки и разрешите Me2 использовать ваше местонахождение"
//            return "Это приложение не авторизовано для использования служб определения местоположения. Из-за активных ограничений на службы определения местоположения пользователь не может изменить этот статус и, возможно, лично не отказывал в авторизации.".localized
        case .denied:
            return "Пожалуйста, откройте настройки и разрешите Me2 использовать ваше местонахождение"
//            return "Пользователь явно отказал в авторизации для этого приложения, или службы определения местоположения отключены в Настройках"
        case .authorizedAlways:
            return nil
        case .authorizedWhenInUse:
            return nil
        @unknown default:
            return "Приложение не может найти вас на карте".localized
        }
    }
}
