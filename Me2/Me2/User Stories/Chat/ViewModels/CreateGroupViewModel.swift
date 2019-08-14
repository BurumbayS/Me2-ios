//
//  CreateGroupViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/6/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

class CreateGroupViewModel {
    let participants: Dynamic<[String]>
    
    init() {
        participants = Dynamic([])
    }
    
    func select(cell : ContactTableViewCell) {
        cell.select()
        
        switch cell.checked {
        case .checked:
            participants.value.append(cell.nameLabel.text ?? "")
        default:
            participants.value.removeLast()
        }
    }
}
