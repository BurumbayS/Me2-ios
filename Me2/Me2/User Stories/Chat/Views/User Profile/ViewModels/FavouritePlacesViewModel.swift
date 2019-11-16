//
//  FavouritePlacesViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/16/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

class FavouritePlacesViewModel {
    var userInfo: Dynamic<User>
    var updatedUserInfo: User
    var toDeletePlaceIndexPath: IndexPath?
    
    init(userInfo: Dynamic<User>) {
        self.userInfo = userInfo
        self.updatedUserInfo = userInfo.value
    }
}
