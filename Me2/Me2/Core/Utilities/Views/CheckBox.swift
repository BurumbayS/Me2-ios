//
//  CheckBox.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/30/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class CheckBox: UIView {
    
    var isChecked = false
    
    let checkBox = UIButton()
    let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        checkBox.setImage(UIImage(named: "unchecked_box_icon"), for: .normal)
        checkBox.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        self.addSubview(checkBox)
        constrain(checkBox, self) { box, view in
            box.left == view.left
            box.top == view.top
            box.bottom == view.bottom
            box.height == 20
            box.width == 20
        }
        
        title.textColor = .darkGray
        title.font = UIFont(name: "Roboto-Regular", size: 13)
        self.addSubview(title)
        constrain(title, checkBox, self) { label, box, view in
            label.left == box.right + 10
            label.centerY == box.centerY
            label.right == view.right
        }
    }
    
    func configure(with title: String) {
        self.title.text = title
    }
    
    @objc private func pressed() {
        isChecked = !isChecked
        
        switch isChecked {
        case true:
            self.checkBox.setImage(UIImage(named: "checked_box_icon"), for: .normal)
        default:
            self.checkBox.setImage(UIImage(named: "unchecked_box_icon"), for: .normal)
        }
    }
    
}
