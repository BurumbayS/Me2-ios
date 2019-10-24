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
    
    var bookingParameter: BookingParameter!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(parameter: BookingParameter) {
        self.bookingParameter = parameter
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
        textView.font = UIFont(name: "Roboto-Regular", size: 17)
        textView.delegate = self
        
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

extension BookingWishesTableViewCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        bookingParameter.data = textView.text
    }
}
