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
    var pageToShow: Dynamic<PlaceProfilePage>
    
    init() {
        pageToShow = Dynamic(.info)
        currentPage = Dynamic(0)
        
        currentPage.bind { [unowned self] (index) in
            switch index {
            case 0:
                self.pageToShow.value = .info
            case 1:
                self.pageToShow.value = .events
            case 2:
                self.pageToShow.value = .menu
            case 3:
                self.pageToShow.value = .reviews
            default:
                break
            }
        }
    }
}
