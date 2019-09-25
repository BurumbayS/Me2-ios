//
//  MapSearchViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/13/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

class MapSearchViewModel {
    let searchValue: Dynamic<String>
    var searchResults = [String]()
    
    init(searchValue: Dynamic<String>) {
        self.searchValue = searchValue
        
        self.searchValue.bind { [unowned self] (value) in
            if value != "" {
                self.searchResults = ["","","",""]
            } else {
                self.searchResults = []
            }
        }
    }
    
    
}
