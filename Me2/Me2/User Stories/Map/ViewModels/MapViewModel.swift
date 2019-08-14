//
//  MapViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/13/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

enum ImhereIcon: String {
    case plain = "map_marker_icon"
    case active = "active_map_marker_icon"
    case inactive = "inactive_map_marker_icon"
}

class MapViewModel {
    var isMyLocationVisible: Dynamic<Bool> = Dynamic(false)
}
