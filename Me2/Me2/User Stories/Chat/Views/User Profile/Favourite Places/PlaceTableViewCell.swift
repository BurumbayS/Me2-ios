//
//  PlaceTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/12/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cosmos

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var availableTime: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
