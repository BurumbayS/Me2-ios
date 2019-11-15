//
//  ManageAccountTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/4/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

enum ManageAccountSectionType {
    case privacy
    case notification
    case security
    case delete
    
    var title: String {
        switch self {
        case .privacy:
            return "Приватность"
        case .notification:
            return "Уведомления"
        case .security:
            return "Безопастность"
        case .delete:
            return ""
        }
    }
}

class ManageAccountParameterModel {
    let title: String
    let type: ManageAccountSectionType
    var notificationParameter: NotificationParameter?
    
    init(title: String, type: ManageAccountSectionType, notificationParameter: NotificationParameter? = nil) {
        self.title = title
        self.type = type
        self.notificationParameter = notificationParameter
    }
}

class ManageAccountTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    let valueLabel = UILabel()
    let switcher = UISwitch()
    
    var notificationParameter: NotificationParameter?
    
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
        case .notification:
            switcher.isHidden = false
            valueLabel.isHidden = true
        case .security:
            switcher.isHidden = true
            valueLabel.isHidden = false
            self.accessoryType = .disclosureIndicator
        case .delete:
            titleLabel.textColor = Color.red
            switcher.isHidden = true
            valueLabel.isHidden = true
        }
    }
    
    func configure(with model: ManageAccountParameterModel) {
        self.notificationParameter = model.notificationParameter
        
        configureViews(with: model)
    }
    
    private func setUpViews() {
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        self.contentView.addSubview(titleLabel)
        constrain(titleLabel, self.contentView) { title, view in
            title.left == view.left + 20
            title.height == 20
            title.top == view.top + 20
            title.bottom == view.bottom - 20
        }
        
        valueLabel.textColor = .darkGray
        valueLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        self.contentView.addSubview(valueLabel)
        constrain(valueLabel, self.contentView) { value, view in
            value.right == view.right - 20
            value.centerY == view.centerY
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
    
    @objc private func switcherValueChanged() {
        notificationParameter?.isOn = switcher.isOn
    }
}
