//
//  ContactTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/6/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

enum CheckStatus: String {
    case checked = "checked"
    case unchecked = "unchecked"
    
    func image() -> UIImage {
        return UIImage(named: self.rawValue) ?? UIImage()
    }
}

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var checkStatusImageView: UIImageView!
    
    var checked = CheckStatus.unchecked
    
    func configure(selectable: Bool) {
        switch selectable {
        case true:
            checkStatusImageView.isHidden = false
            checkStatusImageView.image = checked.image()
        default:
            checkStatusImageView.isHidden = true
        }
    }
    
    func select() {
        switch checked {
        case .checked:
            checked = .unchecked
        default:
            checked = .checked
        }
        
        checkStatusImageView.image = checked.image()
    }
}
