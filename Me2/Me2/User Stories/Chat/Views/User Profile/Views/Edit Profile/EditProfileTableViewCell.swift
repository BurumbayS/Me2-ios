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
    let datePicker = UIDatePicker()
    
    var cellType: EditProfileCell!
    var dataToSave: UserDataToSave!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: [String : String?], userDataToSave: UserDataToSave, cellType: EditProfileCell) {
        self.dataToSave = userDataToSave
        
        titleLabel.text = cellType.title
        textField.delegate = self
        
        self.cellType = cellType
        
        switch cellType {
        case .firstname:
            textField.placeholder = "Альберт"
            textField.text = data["firstname"] ?? ""
        case .lastname:
            textField.placeholder = "Эйнштейн"
            textField.text = data["lastname"] ?? ""
        case .dateOfBirth:
            textField.placeholder = "14 марта 1879"
            textField.text = data["dateOfBirth"] ?? ""
        default:
            break
        }
        
        switch cellType {
        case .dateOfBirth:
            
            datePicker.datePickerMode = .date
            datePicker.locale = Locale(identifier: "ru")
            datePicker.maximumDate = Calendar.current.date(byAdding: .second, value: 0, to: Date())
            textField.inputView = datePicker
            
        default:
            
            break
            
        }
    }
    
    private func setUpViews() {
        titleLabel.textColor = .darkGray
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        self.contentView.addSubview(titleLabel)
        constrain(titleLabel, self.contentView) { label, view in
            label.top == view.top + 20
            label.left == view.left + 20
        }
        
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
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

extension EditProfileTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch cellType {
        case .dateOfBirth?:
            
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.locale = Locale(identifier: "ru")
            textField.text = formatter.string(from: datePicker.date)
            
            formatter.dateFormat = "yyyy-MM-dd"
            dataToSave.data = formatter.string(from: datePicker.date)
            
        default:
            dataToSave.data = textField.text
        }
    }
}
