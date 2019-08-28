//
//  PlaceWorkTimeTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/28/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class PlaceWorkTimeTableViewCell: UITableViewCell {

    let workingTimeLabel = UILabel()
    let closingTimeLabel = UILabel()
    let iconImageView = UIImageView()
    let availabilityStatusView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with workingTime: String, and closingTime: String, isOpen: Bool) {
        workingTimeLabel.text = workingTime
        closingTimeLabel.text = closingTime
        availabilityStatusView.backgroundColor = (isOpen) ? .green : .red
    }
    
    private func setUpViews() {
        iconImageView.image = UIImage(named: "time")
        self.contentView.addSubview(iconImageView)
        constrain(iconImageView, self.contentView) { icon, view in
            icon.width == 20
            icon.height == 20
            icon.left == view.left + 20
            icon.centerY == view.centerY
        }
        
        let view = UIView()
        
        workingTimeLabel.textColor = .gray
        workingTimeLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        view.addSubview(workingTimeLabel)
        constrain(workingTimeLabel, view) { label, view in
            label.top == view.top
            label.left == view.left
            label.right == view.right
        }
        
        closingTimeLabel.textColor = .gray
        closingTimeLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        view.addSubview(closingTimeLabel)
        constrain(closingTimeLabel, workingTimeLabel, view) { closingTimeLabel, workingTimeLabel, view in
            closingTimeLabel.top == workingTimeLabel.bottom
            closingTimeLabel.bottom == view.bottom
            closingTimeLabel.leading == workingTimeLabel.leading
        }
        
        availabilityStatusView.layer.cornerRadius = 3
        availabilityStatusView.backgroundColor = .white
        view.addSubview(availabilityStatusView)
        constrain(availabilityStatusView, closingTimeLabel, view) { status, label, view in
            status.left == label.right + 5
            status.centerY == label.centerY
            status.right == view.right
            status.height == 6
            status.width == 6
        }
        
        self.contentView.addSubview(view)
        constrain(view, iconImageView, self.contentView) { view, icon, contentView in
            view.left == icon.right + 15
            view.right == contentView.right - 22
            view.top == contentView.top + 10
            view.bottom == contentView.bottom - 15
        }
    }
}
