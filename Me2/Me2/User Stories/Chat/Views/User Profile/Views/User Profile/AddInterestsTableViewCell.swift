//
//  AddInterestsTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/2/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class AddInterestsTableViewCell: UITableViewCell {

    let addButton = UIButton()
    let placeHolderLabel = UILabel()
    
    var addActionHandler: VoidBlock?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for profileType: ProfileType, onAddAction: VoidBlock?) {
        self.addActionHandler = onAddAction
        
        switch profileType {
        case .myProfile:
            placeHolderLabel.isHidden = true
        default:
            addButton.isHidden = true
        }
    }
    
    private func setUpViews() {
        addButton.setTitleColor(Color.red, for: .normal)
        addButton.setTitle("+ Добавить интересы", for: .normal)
        addButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
        self.contentView.addSubview(addButton)
        constrain(addButton, self.contentView) { btn, view in
            btn.centerX == view.centerX
            btn.bottom == view.bottom
            btn.top == view.top + 25
            btn.height == 20
        }
        
        placeHolderLabel.textColor = .darkGray
        placeHolderLabel.text = "Интересов пока нет"
        placeHolderLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        self.contentView.addSubview(placeHolderLabel)
        constrain(placeHolderLabel, self.contentView) { label, view in
            label.centerX == view.centerX
            label.bottom == view.bottom
            label.top == view.top + 25
            label.height == 20
        }
    }
    
    @objc private func addButtonPressed() {
        addActionHandler?()
    }
}
