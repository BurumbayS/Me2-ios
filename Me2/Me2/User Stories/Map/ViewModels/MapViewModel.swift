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

class MapViewModel: BaseViewModel {

    private var loadingPlacePins: [PlacePin] = []
    private let radius: CLLocationDistance = 1000
    private let roomURL = Network.chat + "/room/"
    private let placesURL = Network.core + "/place/"

    var placesObservable: Dynamic<[Place]>
    private var currentLiveRoomUUID: String
    let locationManager: LocationManagerInterface

    let placePinsObservable: Dynamic<[PlacePin]>

    var currentPlaceCardIndex: Dynamic<Int>

    private let nearIncludeDistance: Double = 200


    init(currentLiveRoomUUID: String = "",
         currentPlaceCardIndex: Dynamic<Int> = Dynamic(0),
         
         placePinsObservable: Dynamic<[PlacePin]> = .init([]),
         placesObservable: Dynamic<[Place]> = Dynamic<[Place]>.init([]),
         locationManager: LocationManagerInterface = AppLocationManager()) {

        self.placesObservable = placesObservable
        self.locationManager = locationManager
        self.placePinsObservable = placePinsObservable
        self.currentLiveRoomUUID = currentLiveRoomUUID
        self.currentPlaceCardIndex = currentPlaceCardIndex
    }

    override func viewDidLoad() {
        self.locationManager.locationObservable.bind { [weak self] location in
            guard Location.my != location else {
                return
            }
            Location.my = location
        }

        self.locationManager.statusObservable.bind { [weak self] status in
            switch status {
            case .authorized:
                self?.loadAllPlacePins()
            default:
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self?.settingError.value = ("Доступ к геолокации запрещён", "Пожалуйста, откройте настройки и разрешите Me2 использовать ваше местонахождение")
                }
            }
        }
        self.locationManager.startMonitoring()
    }

    func loadAllPlacePins() {
        self.placePinsObservable.value = RealmAdapter.shared.objects(PlacePinDAO.self).map({ $0.place() })
        guard shouldUpdateDB() else {
            return
        }
        let url = placesURL + "?limit=500"
        self.showLoading.value = "Загрука данных"
        self.loadPinsOnRecycleCondition(url: url, completion: self.handleLoadedPins())
    }

    func loadPlaceOnRadius() {
        self.showLoading.value = "Загрука ближайщих заведений"
        let url = placesURL + "?id_list=\(self.nearPlaceIds())"
        self.loadPlaceWithNearIds(url: url) { status in
            switch status {
            case .success(let places):
                self.showHub.value = .success("Успешно")
                self.placesObservable.value = places
            case .fail(let text):
                self.showHub.value = .success("Ошибка\n\(text)")
            }
        }
    }

//
//    func getPlaceCardInfo(with id: Int, completion: ResponseBlock?) {
//        getPlaces(idList: "\(id)", completion: completion)
//    }
//

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
    private func nearPlaceIds() -> String {
        self.placePinsObservable.value.filter { [weak self] place in
            guard let `self` = self else {
                return false
            }
            let distance = self.locationManager.distance(to: .init(latitude: place.latitude, longitude: place.longitude)) ?? 2001
            return distance < self.nearIncludeDistance
        }.compactMap({ $0.id?.description }).joined(separator: ",")
    }
}


private extension MapViewModel {
//switch status {
//case .success(let pins):
//if pins.isEmpty {
//
//} else {
////                       if (self?.viewModel.isMyLocationVisible.value)! && (self?.viewModel.places.count)! > 0 {
////                    self?.showCollectionView()
////                    self?.с()
//
////                       }
//}
//case .fail(let text):
//self.error.value = text
//}


    private func handleLoadedPins() -> (Status<[PlacePin]>) -> () {
        { [weak self] status in
            guard let `self` = self else {
                return
            }
            self.showLoading.value = nil
            switch status {
            case .success(let pins):
                self.updateDB(place: pins)
                self.placePinsObservable.value = pins
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

    @discardableResult
    private func loadPinsOnRecycleCondition(url: String, completion: @escaping (Status<[PlacePin]>) -> ()) -> DataRequest {

        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getHeaders())
                .responseJSON { [weak self] (response) in
                    guard let `self` = self else {
                        return
                    }
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        self.loadingPlacePins.append(contentsOf: json["data"]["results"].arrayValue.map({ PlacePin.convert(from: $0) }))
                        let nextURL = json["data"]["next"].stringValue

                        if nextURL.isEmpty {
                            completion(.success(self.loadingPlacePins))
                            self.loadingPlacePins.removeAll()
                        } else {
                            self.loadPinsOnRecycleCondition(url: nextURL, completion: completion)
                        }

                    case .failure(let error):
                        completion(.fail(error.localizedDescription))
                    }
                }
    }

    @discardableResult
    private func loadPlaceWithNearIds(url: String, completion: @escaping (Status<[Place]>) -> ()) -> DataRequest {
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getHeaders())
                .responseJSON { [weak self] (response) in
                    guard let `self` = self else {
                        return
                    }
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        completion(.success(json["data"]["results"].arrayValue.map({ Place.init(json: $0) })))
                    case .failure(let error):
                        completion(.fail(error.localizedDescription))
                    }
                }
    }

    func updateDB(place pins: [PlacePin]) {
        try? RealmAdapter.shared.write {
            RealmAdapter.shared.delete(RealmAdapter.shared.objects(PlacePinDAO.self))
            RealmAdapter.shared.add(pins.map({ PlacePinDAO.object(fromPlace: $0) }))
        }

        self.updateDBDate()
    }

    func updateDBDate() {
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
