//
//  SectionDateHeaderCollectionReusableView.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/12/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class SectionDateHeaderCollectionReusableView: UICollectionReusableView {
    let dateView = UIView()
    let dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        dateLabel.textColor = .darkGray
        dateLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        dateLabel.textAlignment = .center
        dateView.addSubview(dateLabel)
        constrain(dateLabel, dateView) { label, view in
            label.top == view.top
            label.bottom == view.bottom
            label.left == view.left + 10
            label.right == view.right - 10
        }
        
        dateView.backgroundColor = Color.gray
        dateView.layer.cornerRadius = 10
        self.addSubview(dateView)
        constrain(dateView, self) { date, view in
            date.centerX == view.centerX
            date.centerY == view.centerY
            date.height == 20
        }
    }
    
    func configure(with date: String) {
        dateLabel.text = date
    }
}
