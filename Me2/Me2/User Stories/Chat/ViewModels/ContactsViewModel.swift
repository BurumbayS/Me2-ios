//
//  ContactsViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/8/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

class ContactsViewModel {
    let contactSelectionHandler: ((Int) -> ())?
    
    init(onContactSelected: ((Int) -> ())?) {
        self.contactSelectionHandler = onContactSelected
    }
}
