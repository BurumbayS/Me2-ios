//
//  PlaceDetailsViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/2/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class PlaceDetailsViewModel {
    let pages = [PlaceProfilePage.info, .events, .menu, .reviews]
    
    func getCellClass(for index: Int) -> UICollectionViewCell.Type {
        let page = pages[index]
        
        switch page {
        case .info:
            return PlaceInfoCollectionViewCell.self
        case .menu:
            return PlaceMenuCollectionViewCell.self
        default:
            return UICollectionViewCell.self
        }
    }
}
