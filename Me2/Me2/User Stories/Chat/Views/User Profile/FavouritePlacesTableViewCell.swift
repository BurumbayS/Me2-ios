//
//  FavouritePlacesTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/9/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class FavouritePlacesTableViewCell: UITableViewCell {

    let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        stackView.spacing = -5
        stackView.alignment = .leading
        
        self.contentView.addSubview(stackView)
        constrain(stackView, self.contentView) { stack, view in
            stack.left == view.left
            stack.top == view.top + 10
            stack.bottom == view.bottom - 10
            stack.height == 36
        }
    }
    
    //configure places' logos stack view, cause max number of logos is 3, then it should be like +smth
    func configure(with data: Int) {
        let limit = (data > 3) ? 3 : data
        var x = 0
        for _ in 0..<limit {
            let imageView = UIImageView(frame: CGRect(x: x, y: 0, width: 36, height: 36))
            imageView.layer.cornerRadius = 18
            imageView.image = UIImage(named: "sample_place_logo")
            
            stackView.addSubview(imageView)
            
            x += 30
        }
        
        if data > 3 {
            x += 10
            let label = UILabel(frame: CGRect(x: x, y: 0, width: 100, height: 36))
            label.textColor = .gray
            label.font = UIFont(name: "Roboto-Regular", size: 17)
            label.text = "+\(data - 3)"
            
            stackView.addSubview(label)
        }
    }
}
