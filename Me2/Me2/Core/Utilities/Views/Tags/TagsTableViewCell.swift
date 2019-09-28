//
//  PlaceOptionalsTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/29/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

enum TagsType {
    case selectable
    case unselectable
    
    var tagSize: TagSize {
        switch self {
        case .selectable:
            return .large
        default:
            return .small
        }
    }
}

class TagsTableViewCell: UITableViewCell {
    
    let tags = ["Средний чек 3000тг","Средний чек 3000тг","Заказ на вынос","Бизнес-ланч","Терраса"]
    var tagsType: TagsType!
    var layoutSubviews = false
    
    func configure(with tagsType: TagsType) {
        self.tagsType = tagsType
        
        if !self.layoutSubviews {
            setUpViews()
        }
    }
    
    private func setUpViews() {
        let view = UIView()

        let itemPadding: CGFloat = 10
        let sidesPadding: CGFloat = 20
        
        var x: CGFloat = 0
        var y: CGFloat = 0

        for tag in tags {
            let height = tagsType.tagSize.height
            let width = tag.getWidth(with: tagsType.tagSize.font) + tagsType.tagSize.sidesPadding
            
            if x + width + sidesPadding > UIScreen.main.bounds.width {
                x = 0
                y += tagsType.tagSize.height + itemPadding
            }
            
            let tagView = Tag(frame: CGRect(x: x, y: y, width: width, height: height))
            tagView.configure(with: tag, of: tagsType.tagSize)
            
            view.addSubview(tagView)
            
            x += width + itemPadding
        }
        
        self.contentView.addSubview(view)
        constrain(view, self.contentView) { view, superView in
            view.left == superView.left + sidesPadding
            view.right == superView.right - sidesPadding
            view.top == superView.top + 20
            view.bottom == superView.bottom - 20
            view.height == y + tagsType.tagSize.height
        }
    }
}
