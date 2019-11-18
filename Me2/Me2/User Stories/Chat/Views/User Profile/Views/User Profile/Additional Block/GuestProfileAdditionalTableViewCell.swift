//
//  GuestProfileAdditionalTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/2/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class GuestProfileAdditionalTableViewCell: UITableViewCell {

    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: GuestProfileAdditionalBlockCell) {
        label.text = item.rawValue
        label.textColor = Color.blue
    }
    
    private func setUpViews() {
        let line = UIView()
        line.backgroundColor = Color.gray
        self.contentView.addSubview(line)
        constrain(line, self.contentView) { line, view in
            line.left == view.left + 20
            line.height == 1
            line.right == view.right
            line.top == view.top
        }
        
        label.font = UIFont(name: "Roboto-Regular", size: 15)
        self.contentView.addSubview(label)
        constrain(label, line, self.contentView) { label, line, view in
            label.left == view.left + 20
            label.top == line.top + 15
            label.bottom == view.bottom - 15
        }
    }
}
