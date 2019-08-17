//
//  PlaceProfileHeaderView.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/17/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class PlaceProfileHeaderView: UICollectionReusableView {
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "sample_place_image")
        self.addSubview(imageView)
        constrain(imageView, self) { image, view in
            image.left == view.left
            image.top == view.top
            image.right == view.right
            image.bottom == view.bottom 
        }
    }
}
