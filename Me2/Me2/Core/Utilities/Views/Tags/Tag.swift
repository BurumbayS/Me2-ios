//
//  Tag.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/28/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

enum TagSize {
    case large
    case small
    
    var font: UIFont {
        switch self {
        case .large:
            return UIFont(name: "Roboto-Regular", size: 17)!
        default:
            return UIFont(name: "Roboto-Regular", size: 11)!
        }
    }
    
    var sidesPadding: CGFloat {
        switch self {
        case .large:
            return 40
        default:
            return 20
        }
    }
    
    var height: CGFloat {
        switch self {
        case .large:
            return 30
        default:
            return 25
        }
    }
}

class Tag: UIView {
    
    let label = UILabel()
    
    func configure(with text: String, of tagSize: TagSize) {
        self.backgroundColor = Color.lightGray
        self.layer.cornerRadius = 5
        
        label.textColor = .gray
        label.text = text
        label.font = tagSize.font
        self.addSubview(label)
        constrain(label, self) { label, view in
            label.centerX == view.centerX
            label.centerY == view.centerY
        }
    }
}
