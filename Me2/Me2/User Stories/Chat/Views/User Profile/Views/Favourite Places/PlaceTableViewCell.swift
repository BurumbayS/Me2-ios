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
    @IBOutlet weak var addPlaceView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addedLabel: UILabel!
    
    var addPressHandler: VoidBlock?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.addUnderline(with: Color.gray, and: CGSize(width: self.frame.width, height: self.frame.height))
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with place: Place, cellType: PlaceCellType = .toPresent, added: Bool = false, onAdd: VoidBlock? = nil) {
        placeImageView.kf.setImage(with: URL(string: place.logo ?? ""), placeholder: UIImage(named: "default_place_logo"), options: [])
        nameLabel.text = place.name
        locationLabel.text = place.address1
        ratingView.rating = place.rating ?? 0
        addPlaceView.isHidden = (cellType == .toAdd) ? false : true
        addButton.isHidden = added
        addedLabel.isHidden = !added
        
        self.addPressHandler = onAdd
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        addPressHandler?()
    }
}

enum PlaceCellType {
    case toAdd
    case toPresent
}
