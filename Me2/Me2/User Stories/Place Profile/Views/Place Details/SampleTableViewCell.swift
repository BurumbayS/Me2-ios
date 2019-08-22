//
//  SampleTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/22/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class SampleTableViewCell: UITableViewCell {
    
    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        label.font = UIFont(name: "Roboto-Regular", size: 24)
        label.textColor = Color.red
        self.contentView.addSubview(label)
        constrain(label, self.contentView) { label, cell in
            label.top == cell.top + 10
            label.bottom == cell.bottom - 10
            label.left == cell.left + 10
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with index: Int) {
        label.text = "Hello world \(index + 1)"
    }
}
