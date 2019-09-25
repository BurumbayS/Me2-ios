//
//  EventsSearchViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/25/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

class EventsSearchViewModel {
    let searchValue: Dynamic<String>
    
    init(searchValue: Dynamic<String>) {
        self.searchValue = searchValue
    }
}
