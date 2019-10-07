//
//  PlaceProfileViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/23/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

enum PlaceProfilePage: String  {
    case info = "PlaceInfoCell"
    case events = "PlaceEventsCell"
    case menu = "PlaceMenuCell"
    case reviews = "PlaceReviewsCell"
    
    var cellID: String {
        return self.rawValue
    }
    
    func getCellClass() -> UICollectionViewCell.Type {
        switch self {
        case .info:
            return PlaceInfoCollectionViewCell.self
        case .menu:
            return PlaceMenuCollectionViewCell.self
        case .reviews:
            return PlaceReviewsCollectionViewCell.self
        case .events:
            return PlaceEventsCollectionViewCell.self
        }
    }
}

class PlaceProfileViewModel {
    var currentPage: Dynamic<Int>
    var pageToShow: Dynamic<PlaceProfilePage>
    var placeStatus: PlaceStatus
    
    init() {
        pageToShow = Dynamic(.info)
        currentPage = Dynamic(0)
        placeStatus = .registered
        
        currentPage.bind { [unowned self] (index) in
            self.pageToShow.value = self.placeStatus.pages[index]
        }
    }
}
