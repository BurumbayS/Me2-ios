//
//  EditProfileTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/3/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class EditProfileTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    let textField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, placeholder: String) {
        titleLabel.text = title
        textField.placeholder = placeholder
    }
    
    private func setUpViews() {
        titleLabel.textColor = .darkGray
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        self.contentView.addSubview(titleLabel)
        constrain(titleLabel, self.contentView) { label, view in
            label.top == view.top + 20
            label.left == view.left + 20
        }
        
        textField.borderStyle = .none
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .white
        textField.font = UIFont(name: "Roboto-Regular", size: 15)
        self.contentView.addSubview(textField)
        constrain(textField, titleLabel, self.contentView) { textField, label, view in
            textField.left == view.left + 20
            textField.top == label.bottom + 5
            textField.right == view.right - 20
            textField.bottom == view.bottom
            textField.height == 40
        }
    }
}
