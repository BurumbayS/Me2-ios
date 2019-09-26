//
//  PlaceOptionalCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/29/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class TagCollectionViewCell: UICollectionViewCell {
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        label.text = text
    }
    
    private func setUpViews() {
        let view = UIView()
        view.backgroundColor = Color.lightGray
        view.layer.cornerRadius = 5
        
        label.textColor = .gray
        label.font = UIFont(name: "Roboto-Regular", size: 11)
        view.addSubview(label)
        constrain(label, view) { label, view in
            label.centerX == view.centerX
            label.centerY == view.centerY
        }
        
        self.contentView.addSubview(view)
        constrain(view, self.contentView) { view, superView in
            view.top == superView.top
            view.bottom == superView.bottom
            view.left == superView.left
            view.right == superView.right
        }
    }
}
