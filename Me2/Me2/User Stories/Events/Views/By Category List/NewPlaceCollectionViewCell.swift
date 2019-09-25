//
//  NewPlaceCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/24/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class NewPlaceCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeView: UIButton!
    
    func configure() {
        titleLabel.text = "Мята"
        typeView.setTitle("Ресторан", for: .normal)
    }

}
