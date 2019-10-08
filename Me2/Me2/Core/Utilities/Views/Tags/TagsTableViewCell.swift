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
    case normal
    
    var tagSize: TagSize {
        switch self {
        case .selectable:
            return .large
        case .normal:
            return .medium
        case .unselectable:
            return .small
        }
    }
}

class TagsList {
    var list = [String]()
    var selectedList = [String]()
}

class TagsTableViewCell: UITableViewCell {
    
    let tags = ["Средний чек 3000тг","Средний чек 3000тг","Заказ на вынос","Бизнес-ланч","Терраса", "Заказ на вынос","Бизнес-ланч","Терраса"]
    var tagsList: TagsList!
    var tagsType: TagsType!
    
    var expanded: Dynamic<Bool>!
    
    var minVisibleTagsViewHeight: CGFloat = 0
    var originalTagsViewHeight: CGFloat = 0
    var visibleTagsViewHeight: CGFloat = 0
    
    var layoutSubviews = false
    
    func configure(tagsType: TagsType, tagsList: TagsList, expanded: Dynamic<Bool> = Dynamic(true)) {
        self.tagsType = tagsType
        self.tagsList = tagsList
        self.expanded = expanded
        
        if !self.layoutSubviews {
            setUpViews()
        }
        
        bindDynamics()
    }
    
    private func bindDynamics() {
        expanded.bind { [weak self] (isExpanded) in
            switch isExpanded {
            case true:
                self?.visibleTagsViewHeight = self?.originalTagsViewHeight ?? 0
            case false:
                self?.visibleTagsViewHeight = self?.minVisibleTagsViewHeight ?? 0
            }
        }
    }
    
    private func setUpViews() {
        let view = UIView()

        let itemPadding: CGFloat = 10
        let sidesPadding: CGFloat = 20
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        var rows = 1

        for tag in tags {
            let height = tagsType.tagSize.height
            let width = tag.getWidth(with: tagsType.tagSize.font) + tagsType.tagSize.sidesPadding
            
            if x + width + sidesPadding > UIScreen.main.bounds.width {
                x = 0
                y += tagsType.tagSize.height + itemPadding
                
                rows += 1
            }
            
            let tagView = Tag(frame: CGRect(x: x, y: y, width: width, height: height))
            tagView.configure(with: tag, and: tagsList, of: tagsType.tagSize)
            
            view.addSubview(tagView)
            
            x += width + itemPadding
        }
        
        if rows >= 2 {
            minVisibleTagsViewHeight = tagsType.tagSize.height * 2
        } else {
            minVisibleTagsViewHeight = tagsType.tagSize.height
        }
        
        originalTagsViewHeight = y + tagsType.tagSize.height
        visibleTagsViewHeight = (expanded.value) ? originalTagsViewHeight : minVisibleTagsViewHeight
        
        self.contentView.addSubview(view)
        constrain(view, self.contentView) { view, superView in
            view.left == superView.left + sidesPadding
            view.right == superView.right - sidesPadding
            view.top == superView.top + 20
            view.bottom == superView.bottom - 20
            view.height == visibleTagsViewHeight
        }
    }
}
 
