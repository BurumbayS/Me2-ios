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
    var stopWithStatus: Dynamic<Status<String>> = .init(.success(""))

    func viewDidLoad() {
    }
}

class MapViewModel: BaseViewModel {

    private let placesURL = Network.core + "/place/"
    private let roomURL = Network.chat + "/room/"

    private let radius: CLLocationDistance = 1000


    var places: [Place]
    var placePins: [PlacePin]
    var currentLiveRoomUUID: String
    var isMyLocationVisible: Dynamic<Bool>
    var currentPlaceCardIndex: Dynamic<Int>

    let locationManager: LocationManagerInterface
    private var settingError: Dynamic<String?> = Dynamic.init(nil)

    init(places: [Place] = [],
         placePins: [PlacePin] = [],
         currentLiveRoomUUID: String = "",
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
                self?.placePins.removeAll()
                self?.loadPlacePins()
            default:
                self?.settingError.value = status.errorReason
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
        self.placePins = RealmAdapter.shared.objects(PlacePinDAO.self).map({ $0.place() })

        guard shouldUpdateDB() else {
            return
        }

        let url = placesURL + "?limit=500"
        getPlaces(at: url) { [weak self] status in
            switch status {
            case .success:
                self?.stopWithStatus.value = .success("Данные успешно скачены")
            case .fail(let text):
                self?.error.value = text
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
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getHeaders())
                .responseJSON { [weak self] (response) in
                    guard let `self` = self else { return }
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        self.placePins.append(contentsOf: json["data"]["results"].arrayValue.map({ PlacePin.convert(from: $0) }))
                        let nextURL = json["data"]["next"].stringValue
                        if nextURL.isEmpty {
                            completion(.success(self.placePins))
                        } else {
                            self.getPlaces(at: nextURL, completion: completion)
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
        }

        placePins.forEach { pin in
            RealmAdapter.write(object: PlacePinDAO.object(fromPlace: pin))
        }
        self.updateDBDate()
    }

    private func updateDBDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"

        let date = Date()

        UserDefaults().set(dateFormatter.string(from: date), forKey: UserDefaultKeys.lastDbUpdate.rawValue)
    }


//      self.getPlacePins { [weak self] (status, message) in
//            switch status {
//            case .ok:
//                self?.stopLoader()
//                self?.setUpCLusterManager()
//                self?.showHint()
//            case .error, .fail:
//
//            }
//        }
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
