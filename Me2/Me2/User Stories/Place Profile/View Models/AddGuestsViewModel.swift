//
//  AddGuestsViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/1/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

class AddGuestViewModel {
    
    var guests = [String]()
    let completion: (([String]) -> ())?
    
    init(onCompletion: (([String]) -> ())?) {
        self.completion = onCompletion
    }
    
    func select(cell : ContactTableViewCell) {
        cell.select()
        
        switch cell.checked {
        case .checked:
            guests.append(cell.nameLabel.text ?? "")
        default:
            guests.removeLast()
        }
    }
    
    func completeWithSelection() {
        completion?(guests)
    }
}
