//
//  PlaceDetailsViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/2/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class PlaceDetailsViewModel {
    var cells = [String : PlaceDetailCollectionCell]()
    let placeStatus: PlaceStatus
    let currentPage: Dynamic<Int>
    let place: Place
    
    init(place: Place, currentPage: Dynamic<Int>) {
        self.place = place
        self.placeStatus = place.regStatus
        self.currentPage = currentPage
    }
}
