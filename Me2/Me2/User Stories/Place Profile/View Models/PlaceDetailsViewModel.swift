//
//  PlaceDetailsViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/2/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class PlaceDetailsViewModel {
//    let pages = [PlaceProfilePage.info, .events, .menu, .reviews]
//    let pages = [PlaceProfilePage.info, .reviews]
    var cells = [String : PlaceDetailCollectionCell]()
    let placeStatus: PlaceStatus
    let currentPage: Dynamic<Int>
    
    init(placeStatus: PlaceStatus, currentPage: Dynamic<Int>) {
        self.placeStatus = placeStatus
        self.currentPage = currentPage
    }
}
