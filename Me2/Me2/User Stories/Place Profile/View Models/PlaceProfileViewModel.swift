//
//  PlaceProfileViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/23/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

enum PlaceProfilePage {
    case info
    case events
    case menu
    case reviews
}

class PlaceProfileViewModel {
    var currentPage: Dynamic<Int>
    var pageToShow: PlaceProfilePage
    
    init() {
        pageToShow = .info
        currentPage = Dynamic(0)
    }
}
