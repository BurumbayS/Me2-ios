//
//  PlaceDetailCollectionCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/2/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class PlaceDetailCollectionCell: UICollectionViewCell {
    var presenterDelegate: ControllerPresenterDelegate!
    
    func configure(presenterDelegate: ControllerPresenterDelegate) {
        self.presenterDelegate = presenterDelegate
    }
    
    func reload() {}
}
