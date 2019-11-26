//
//  ManageAccountTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/4/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class ManageAccountTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    let valueLabel = UILabel()
    let switcher = UISwitch()
    let pickerView = UIPickerView()
    let pickerTextField = UITextField()
    
    var notificationParameter: NotificationParameter?
    var visibilityParameter: VisibilityParameter?
    let pickerParameters = [VisibilityStatus.ALWAYS, .INSIDE, .NEVER]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews(with model: ManageAccountParameterModel) {
        titleLabel.textColor = .black
        titleLabel.text = model.title
        
        switch model.type {
        case .privacy:
            switcher.isHidden = true
            valueLabel.isHidden = false
            valueLabel.text = visibilityParameter?.value.title
            self.accessoryType = .none
        case .notification:
            switcher.isHidden = false
            switcher.isOn = notificationParameter?.isOn ?? false
            valueLabel.isHidden = true
            self.accessoryType = .none
        case .security:
            switcher.isHidden = true
            valueLabel.isHidden = false
            self.accessoryType = .disclosureIndicator
            if model.securityParameterType == .accessCode {
                if let _ = UserDefaults().object(forKey: UserDefaultKeys.accessCode.rawValue) {
                    valueLabel.text = "Вкл"
                } else {
                    valueLabel.text = "Откл"
                }
            }
        case .delete:
            titleLabel.textColor = Color.red
            switcher.isHidden = true
            valueLabel.isHidden = true
            self.accessoryType = .none
        }
    }
    
    func configure(with model: ManageAccountParameterModel) {
        self.notificationParameter = model.notificationParameter
        self.visibilityParameter = model.visibilityParameter
        
        configureViews(with: model)
    }
    
    private func setUpViews() {
        pickerView.layer.borderWidth = 1
        pickerView.layer.borderColor = Color.gray.cgColor
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = Color.lightGray
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = false
        toolBar.tintColor = Color.blue
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Готово", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Отмена", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        pickerTextField.inputView = pickerView
        pickerTextField.inputAccessoryView = toolBar
        pickerTextField.isHidden = true
        self.contentView.addSubview(pickerTextField)
        
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        self.contentView.addSubview(titleLabel)
        constrain(titleLabel, self.contentView) { title, view in
            title.left == view.left + 20
            title.height == 20
            title.top == view.top + 20
            title.bottom == view.bottom - 20
            title.width == 210
        }
        
        valueLabel.textColor = .darkGray
        valueLabel.textAlignment = .right
        valueLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        self.contentView.addSubview(valueLabel)
        constrain(valueLabel, titleLabel, self.contentView) { value, title, view in
            value.right == view.right - 20
            value.centerY == view.centerY
            value.left == title.right + 10
        }
        
        switcher.addTarget(self, action: #selector(switcherValueChanged), for: .valueChanged)
        self.contentView.addSubview(switcher)
        constrain(switcher, self.contentView) { switcher, view in
            switcher.right == view.right - 20
            switcher.height == 32
            switcher.width == 52
            switcher.centerY == view.centerY
        }
        
    }
    
    @objc private func donePicker() {
        let row = pickerView.selectedRow(inComponent: 0)
        
        visibilityParameter?.value = pickerParameters[row]
        valueLabel.text = pickerParameters[row].title
        
        pickerTextField.resignFirstResponder()
    }
    
    @objc private func cancelPicker() {
        pickerTextField.resignFirstResponder()
    }
    
    @objc private func switcherValueChanged() {
        notificationParameter?.isOn = switcher.isOn
    }
}

extension ManageAccountTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerParameters.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerParameters[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        visibilityParameter?.value = pickerParameters[row]
        valueLabel.text = pickerParameters[row].title
    }
}
