//
//  RemovableTag.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/4/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class RemovableTag: UIView {

    let label = UILabel()
    
    var isSelected = false
    var onRemoveHandler: VoidBlock?
    
    func configure(with text: String, onRemove: VoidBlock?) {
        self.onRemoveHandler = onRemove
        
        label.text = text
        
        configureViews()
    }
    
    private func configureViews() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        
        label.textColor = .gray
        label.font = UIFont(name: "Roboto-Regular", size: 15)
        self.addSubview(label)
        constrain(label, self) { label, view in
            label.centerY == view.centerY
            label.left == view.left + 10
        }
        
        let removeButton = UIButton()
        removeButton.setImage(UIImage(named: "red_x_icon"), for: .normal)
        removeButton.addTarget(self, action: #selector(removeTag), for: .touchUpInside)
        self.addSubview(removeButton)
        constrain(removeButton, self) { btn, view in
            btn.height == 15
            btn.width == 15
            btn.right == view.right - 10
            btn.centerY == view.centerY
        }
    }
    
    @objc private func removeTag() {
        onRemoveHandler?()
    }
    
}
