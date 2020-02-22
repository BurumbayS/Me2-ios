//
//  PlaceDAO.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 2/6/20.
//  Copyright © 2020 AVSoft. All rights reserved.
//

import RealmSwift

class PlacePinDAO: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name = ""
    @objc dynamic var logo: String?
    @objc dynamic var longitude: Double = 0
    @objc dynamic var latitude: Double = 0
    
    func place() -> PlacePin {
        let placePin = PlacePin()
        
        placePin.id = self.id
        placePin.name = self.name
        placePin.logo = self.logo
        placePin.longitude = self.longitude
        placePin.latitude = self.latitude
        
        return placePin
    }
    
    static func object(fromPlace place: PlacePin) -> PlacePinDAO {
        let object = PlacePinDAO()
        object.id = place.id
        object.name = place.name
        object.logo = place.logo
        object.latitude = place.latitude
        object.longitude = place.longitude
        
        return object
    }
}
