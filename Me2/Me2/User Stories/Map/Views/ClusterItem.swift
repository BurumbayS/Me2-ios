//
//  ClusterItem.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 2/17/20.
//  Copyright © 2020 AVSoft. All rights reserved.
//

import Foundation

class ClusterItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String!
    var icon: String?

    init(position: CLLocationCoordinate2D, name: String, icon: String?) {
        self.position = position
        self.name = name
        self.icon = icon
    }
}
