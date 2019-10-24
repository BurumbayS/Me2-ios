//
//  EventAddressTimeTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/26/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class EventAddressTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with address: String, and time: String) {
        addressLabel.text = address
        timeLabel.text = time
    }
    
}
