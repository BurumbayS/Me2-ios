//
//  Location.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 2/24/20.
//  Copyright © 2020 AVSoft. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    static var my = CLLocation()

    // calculate distance from my location in km with 1 item after point
    static func distance(from location: CLLocation) -> Double {
        let distance = my.distance(from: location)

        let distanceInkm = Double(Int(distance / 100)) / 10

        return distanceInkm
    }
}

protocol LocationManagerInterface: class {
    var statusObservable: Dynamic<CLAuthorizationStatus> { get set }
    var locationObservable: Dynamic<CLLocation> { get set }
    func stopMonitoring()
    func startMonitoring()
    func distance(to location: CLLocation) -> Double?
    func locationCoordinate2D() -> CLLocationCoordinate2D
}

class AppLocationManager: NSObject, LocationManagerInterface {

    var statusObservable: Dynamic<CLAuthorizationStatus>
    var locationObservable: Dynamic<CLLocation>

    private var locationManager: CLLocationManager = .init()

    private let testlocation: CLLocation = .init(latitude: 43.245116, longitude: 76.937120)


    init(statusObservable: Dynamic<CLAuthorizationStatus> = .init(.denied),
         locationObservable: Dynamic<CLLocation> = .init(CLLocation()),
         locationManager: CLLocationManager = .init()) {
        self.locationManager = locationManager
        self.statusObservable = statusObservable
        self.locationObservable = locationObservable
    }


    func stopMonitoring() {
        self.locationManager.stopUpdatingLocation()
    }

    func startMonitoring() {
        guard CLLocationManager.locationServicesEnabled() else {
            self.statusObservable.value = .notDetermined
            return
        }
        self.locationManager.delegate = self
//        MARK: Battery life economy
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    func distance(to location: CLLocation) -> Double? {
        return self.locationObservable.value.distance(from: location)
    }

    func locationCoordinate2D() -> CLLocationCoordinate2D {
        return self.locationObservable.value.coordinate
    }
}


extension AppLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        self.locationObservable.value = testlocation
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.statusObservable.value = status
    }
}
