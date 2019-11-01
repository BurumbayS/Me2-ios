//
//  EventCategoriesType.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/16/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

enum EventCategoriesType: String {
    case saved
    case popular
    case favourite_places
    case actual
    case new_places
    case all
    
    var title: String {
        switch self {
        case .saved:
            return ""
        case .popular:
            return "Популярное сегодня"
        case .favourite_places:
            return "Подписки"
        case .actual:
            return "Актуальное в Алматы"
        case .new_places:
            return "Новые места"
        case .all:
            return ""
        }
    }
    
    var cellID: String {
        switch self {
        case .popular:
            return "PopularEventsCell"
        case .favourite_places:
            return "FavouriteEventsCell"
        case .actual:
            return "ActualEventsCell"
        default:
            return ""
        }
    }
}
