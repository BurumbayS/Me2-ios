//
//  WaveCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/19/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class WaveCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var blockButton: UIButton!
    @IBOutlet weak var wavBackButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
    }

    private func configureViews() {
        blockButton.layer.borderWidth = 1
        blockButton.layer.borderColor = Color.red.cgColor
        blockButton.layer.cornerRadius = 18
        
        wavBackButton.layer.borderWidth = 1
        wavBackButton.layer.borderColor = Color.blue.cgColor
        wavBackButton.layer.cornerRadius = 18
    }
}
