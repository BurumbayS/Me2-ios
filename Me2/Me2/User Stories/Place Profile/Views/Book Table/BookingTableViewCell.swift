//
//  BookingTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/30/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography
import IQKeyboardManagerSwift

class BookingTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let textField = AttributedTextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        titleLabel.textColor = .darkGray
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        
        self.contentView.addSubview(titleLabel)
        constrain(titleLabel, self.contentView) { label, view in
            label.left == view.left + 20
            label.top == view.top + 25
        }
        
        let star = UILabel()
        star.textColor = Color.red
        star.text = "*"
        star.font = UIFont(name: "Roboto-Regular", size: 13)
        self.contentView.addSubview(star)
        constrain(star, titleLabel) { star, label in
            star.left == label.right + 5
            star.centerY == label.centerY
        }
        
        textField.rightPadding = 10
        textField.borderStyle = .roundedRect
        self.contentView.addSubview(textField)
        constrain(textField, titleLabel, self.contentView) { textField, label, view in
            textField.left == view.left + 20
            textField.right == view.right - 20
            textField.top == label.bottom + 10
        }
    }
    
}

extension BookingTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = "\(row + 1)"
    }
}
