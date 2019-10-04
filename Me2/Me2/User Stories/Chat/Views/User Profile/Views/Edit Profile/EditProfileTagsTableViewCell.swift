//
//  EditProfileTagsTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/4/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class EditProfileTagsTableViewCell: UITableViewCell {

    var tags = ["Танцы", "Танцы", "Литература", "Космос"]
    var tagViews = [RemovableTag]()
    var layoutSubviews = false
    
    let tagsView = UIView()
    
    var tagsViewHeight: CGFloat = 0
    let itemPadding: CGFloat = 10
    let itemHeight: CGFloat = 30
    let sidesPadding: CGFloat = 20
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        if !self.layoutSubviews {
            setUpViews()
        }
    }
    
    private func setUpViews() {
        setUpTags()
        
        self.contentView.addSubview(tagsView)
        constrain(tagsView, self.contentView) { view, superView in
            view.left == superView.left + sidesPadding
            view.right == superView.right - sidesPadding
            view.top == superView.top + 20
            view.bottom == superView.bottom - 20
            view.height == tagsViewHeight
        }
    }
    
    private func setUpTags() {
        tagViews.forEach { $0.removeFromSuperview() }
        tagViews = []
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        for (i, tag) in tags.enumerated() {
            let width = tag.getWidth(with: UIFont(name: "Roboto-Regular", size: 15)!) + 40
            
            if x + width + sidesPadding > UIScreen.main.bounds.width {
                x = 0
                y += itemHeight + itemPadding
            }
            
            let tagView = RemovableTag(frame: CGRect(x: x, y: y, width: width, height: itemHeight))
            tagView.configure(with: tag) { [weak self] in
                self?.removeTag(at: i)
            }
            tagViews.append(tagView)
            
            tagsView.addSubview(tagView)
            
            x += width + itemPadding
        }
        
        tagsViewHeight = y + itemHeight
    }
    
    private func removeTag(at index: Int) {
        tags.remove(at: index)
        setUpTags()
    }

}
