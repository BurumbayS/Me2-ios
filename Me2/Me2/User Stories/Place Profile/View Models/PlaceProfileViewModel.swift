//
//  PlaceProfileViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/23/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

enum PlaceProfilePage: String  {
    case info = "PlaceInfoCell"
    case events = "PlaceEventsCell"
    case menu = "PlaceMenuCell"
    case reviews = "PlaceReviewsCell"
    
    var cellID: String {
        return self.rawValue
    }
}

class PlaceProfileViewModel {
    var currentPage: Dynamic<Int>
    var pageToShow: PlaceProfilePage
    
    init() {
        pageToShow = .info
        currentPage = Dynamic(0)
    }
}
