//
//  ListOfAllViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/25/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

enum ListItemType {
    case event
    case place
}

class ListOfAllViewModel {
    let listItemType: ListItemType
    
    init(listItemType: ListItemType) {
        self.listItemType = listItemType
    }
}
