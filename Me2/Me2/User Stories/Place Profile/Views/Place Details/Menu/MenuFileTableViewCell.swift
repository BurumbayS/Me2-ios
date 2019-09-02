//
//  MenuFileTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/2/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class MenuFileTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    let additionalTitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        titleLabel.text = title
        additionalTitleLabel.text = "Документ PDF 250KB"
    }
    
    private func setUpViews() {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.drawShadow(color: UIColor.darkGray.cgColor, forOpacity: 0.5, forOffset: CGSize(width: 0, height: 0), radius: 2)
        
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Roboto-Medium", size: 17)
        view.addSubview(titleLabel)
        constrain(titleLabel, view) { title, view in
            title.top == view.top + 15
            title.left == view.left + 15
            title.height == 20
        }
        
        additionalTitleLabel.textColor = .darkGray
        additionalTitleLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        view.addSubview(additionalTitleLabel)
        constrain(additionalTitleLabel, titleLabel, view) { secondTitle, title, view in
            secondTitle.top == title.bottom + 5
            secondTitle.left == view.left + 15
            secondTitle.height == 15
            secondTitle.bottom == view.bottom - 15
            secondTitle.trailing == title.trailing
        }
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "file_icon")
        view.addSubview(iconImageView)
        constrain(iconImageView, titleLabel, view) { icon, title, view in
            icon.left == title.right + 10
            icon.right == view.right - 15
            icon.height == 25
            icon.width == 20
            icon.centerY == view.centerY
        }
        
        self.contentView.addSubview(view)
        constrain(view, self.contentView) { view, superView in
            view.left == superView.left + 20
            view.right == superView.right - 20
            view.top == superView.top + 10
            view.bottom == superView.bottom - 10
        }
    }
}
