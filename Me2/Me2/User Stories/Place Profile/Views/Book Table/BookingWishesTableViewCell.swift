//
//  BookingWishesTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/1/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class BookingWishesTableViewCell: UITableViewCell {

    let textView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        let label = UILabel()
        label.textColor = .darkGray
        label.text = "Ваши пожелания к брони"
        label.font = UIFont(name: "Roboto-Regular", size: 13)
        
        self.contentView.addSubview(label)
        constrain(label, self.contentView) { label, view in
            label.left == view.left + 20
            label.top == view.top + 25
        }
        
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = Color.gray.cgColor
        textView.layer.cornerRadius = 10
        
        self.contentView.addSubview(textView)
        constrain(textView, label, self.contentView) { textView, label, view in
            textView.left == view.left + 20
            textView.top == label.bottom + 10
            textView.bottom == view.bottom
            textView.height == 66
            textView.right == view.right - 20
        }
    }
}
