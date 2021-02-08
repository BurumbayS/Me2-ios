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

class BaseViewModel {
    var showLoading: Dynamic<String?> = .init(nil)
    var error: Dynamic<String?> = .init(nil)
    var settingError: Dynamic<(title: String, message: String)?> = Dynamic.init(nil)
    var stopWithStatus: Dynamic<Status<String>> = .init(.success(""))

    func viewDidLoad() {
    }
}

class MapViewModel: BaseViewModel {

    private let placesURL = Network.core + "/place/"
    private let roomURL = Network.chat + "/room/"

    private let radius: CLLocationDistance = 1000


    var places: [Place]
    let placePins: Dynamic<[PlacePin]>
    var currentLiveRoomUUID: String
    var isMyLocationVisible: Dynamic<Bool>
    var currentPlaceCardIndex: Dynamic<Int>

    let locationManager: LocationManagerInterface

    init(places: [Place] = [],
         currentLiveRoomUUID: String = "",
         placePins: Dynamic<[PlacePin]> = .init([]),
         currentPlaceCardIndex: Dynamic<Int> = Dynamic(0),
         isMyLocationVisible: Dynamic<Bool> = Dynamic(false),
         locationManager: LocationManagerInterface = AppLocationManager()) {

        self.places = places
        self.placePins = placePins
        self.locationManager = locationManager
        self.isMyLocationVisible = isMyLocationVisible
        self.currentLiveRoomUUID = currentLiveRoomUUID
        self.currentPlaceCardIndex = currentPlaceCardIndex
    }

    override func viewDidLoad() {
        self.locationManager.locationObservable.bind { location in
            Location.my = location
        }

        self.locationManager.statusObservable.bind { [weak self] status in
            switch status {
            case .authorized, .authorizedAlways, .authorizedWhenInUse:
                self?.placePins.value = []
                self?.loadPlacePins()
            default:
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self?.settingError.value = ("Доступ к геолокации запрещён", "Пожалуйста, откройте настройки и разрешите Me2 использовать ваше местонахождение")
                }
            }
        }

        self.locationManager.startMonitoring()
    }

//
//    func getPlacesInRadius(completion: ResponseBlock?) {
//        let idList = getPlacesInRadiusAsString()
//        if idList.isEmpty {
//            places = []
//            completion?(.ok, "")
//        } else {
//            getPlaces(idList: idList, completion: completion)
//        }
//    }
//
//    func getPlaceCardInfo(with id: Int, completion: ResponseBlock?) {
//        getPlaces(idList: "\(id)", completion: completion)
//    }
//
//    private func getPlaces(idList: String, completion: ResponseBlock?) {
//        let url = placesURL + "?id_list=\(idList)"
//        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
//
//        Alamofire.request(encodedUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getHeaders())
//            .responseJSON { (response) in
//                switch response.result {
//                case .success(let value):
//                    self.places = JSON(value)["data"]["results"].arrayValue
//                            .map({ Place(json: $0) })
//                            .map { [weak self] place -> Place in
//                                place.distance = self?.locationManager.distance(to: place.location)
//                                return place
//                            }
//                            .sorted(by: { $0.distance ?? 0 < $1.distance ?? 0 })
//                    completion?(.ok, "")
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    completion?(.fail, "")
//                }
//        }
//    }
//
//    func enterNewRoom(at index: Int) {
//        let prevLiveRoomUUID = currentLiveRoomUUID
//        currentLiveRoomUUID = places[index].roomInfo?.uuid ?? ""
//
//        exitLiveRoom(with: prevLiveRoomUUID)
//        enterLiveRoom(with: currentLiveRoomUUID)
//    }
//
//    func exitAllRooms() {
//        exitLiveRoom(with: currentLiveRoomUUID)
//
//        currentLiveRoomUUID = ""
//    }
//
//    private func enterLiveRoom(with uuid: String) {
//        let url = roomURL + "\(uuid)/enter/"
//
//        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders())
//            .responseJSON { (response) in
//                switch response.result {
//                case .success(let value):
//
//                    let json = JSON(value)
//                    print(json)
//
//                    if json["code"].intValue == 0 {
//                        UserDefaults().set(uuid, forKey: UserDefaultKeys.enteredRoom.rawValue)
//                    }
//
//                case .failure(let errorR):
//                    self.error.value = errorR.localizedDescription
//                }
//        }
//    }
//
//    private func exitLiveRoom(with uuid: String) {
//        let url = roomURL + "\(uuid)/exit/"
//
//        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders())
//            .responseJSON { (response) in
//                switch response.result {
//                case .success(let value):
//
//                    let json = JSON(value)
//                    print(json)
//
//                    if json["code"].intValue == 0 {
//                        UserDefaults().removeObject(forKey: UserDefaultKeys.enteredRoom.rawValue)
//                    }
//
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//        }
//    }
//
//    private func getPlacesInRadiusAsString() -> String {
//        self.placePins.filter { [weak self] place in
//            guard let distance = self?.locationManager.distance(to: .init(latitude: place.latitude, longitude: place.longitude)) else {
//                return false
//            }
//            return distance < 200
//        }.compactMap({ $0.id?.description }).joined(separator: ",")
//    }
//
}


private extension MapViewModel {
    
    func loadPlacePins() {
//        self.placePins.value = RealmAdapter.shared.objects(PlacePinDAO.self).map({ $0.place() })
//
//        guard shouldUpdateDB() else {
//            return
//        }
        self.showLoading.value = "Загрука данных"
        let url = placesURL + "?limit=500"
        getPlaces(at: url) { [weak self] status in
            guard let `self` = self else {
                return
            }
            self.showLoading.value = nil
            switch status {
            case .success(let pins):
                self.updateDB(place: pins)
                self.placePins.value = pins + self.placePins.value
            case .fail(let text):
                self.error.value = text
            }
        }
    }

    func shouldUpdateDB() -> Bool {
        guard  let prevUpdatedDate = UserDefaults().object(forKey: UserDefaultKeys.lastDbUpdate.rawValue) as? String else {
            return true
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"

        let date = Date()
        let prevDate = dateFormatter.date(from: prevUpdatedDate)

        let components = Calendar.current.dateComponents([.hour], from: prevDate!, to: date)
        let diff = components.hour!

        return diff > 24
    }

    private func getPlaces(at url: String, completion: @escaping (Status<[PlacePin]>) -> Void) {
        var totalPins: [PlacePin] = []
        loadPinsOnRecycleCondition(url: url) { [weak self] status in
            switch status {
            case .success(let pins):
                totalPins.append(contentsOf: pins)
                if pins.isEmpty {
                    completion(.success(totalPins))
                }
            case .fail(let text):
                completion(.fail(text))
            }
        }
    }

    private func loadPinsOnRecycleCondition(url: String, completion: @escaping (Status<[PlacePin]>) -> ()) -> DataRequest {
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getHeaders())
                .responseJSON { [weak self] (response) in
                    guard let `self` = self else {
                        return
                    }
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        let placePins = json["data"]["results"].arrayValue.map({ PlacePin.convert(from: $0) })
                        let nextURL = json["data"]["next"].stringValue
                        completion(.success(placePins))
                        if nextURL.isEmpty {
                            completion(.success([]))
                        } else {
                            self.loadPinsOnRecycleCondition(url: nextURL, completion: completion)
                        }

                    case .failure(let error):
                        completion(.fail(error.localizedDescription))
                    }
                }
    }

    private func updateDB(place pins: [PlacePin]) {
        let allPlacePins = RealmAdapter.shared.objects(PlacePinDAO.self)
        try! RealmAdapter.shared.write {
            RealmAdapter.shared.delete(allPlacePins)
            RealmAdapter.shared.add(pins.map({ PlacePinDAO.object(fromPlace: $0) }))
        }

        self.updateDBDate()
    }

    private func updateDBDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"

        let date = Date()

        UserDefaults().set(dateFormatter.string(from: date), forKey: UserDefaultKeys.lastDbUpdate.rawValue)
    }
}

extension CLAuthorizationStatus {
    var errorReason: String? {
        switch self {

        case .notDetermined:
            return "Пользователь еще не сделал выбор в отношении этого приложения".localized
        case .restricted:
            return "Это приложение не авторизовано для использования служб определения местоположения. Из-за активных ограничений на службы определения местоположения пользователь не может изменить этот статус и, возможно, лично не отказывал в авторизации.".localized
        case .denied:
            return "Пользователь явно отказал в авторизации для этого приложения, или службы определения местоположения отключены в Настройках"
        case .authorizedAlways:
            return nil
        case .authorizedWhenInUse:
            return nil
        @unknown default:
            return "Приложение не может найти вас на карте".localized
        }
    }
}
