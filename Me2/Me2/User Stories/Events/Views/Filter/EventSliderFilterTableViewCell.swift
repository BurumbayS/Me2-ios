//
//  EventSliderFilterTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/28/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import RangeSeekSlider

class EventSliderFilterTableViewCell: UITableViewCell {

    @IBOutlet weak var rangeView: RangeSeekSlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureSlider()
    }
    
    private func configureSlider() {
        rangeView.minValue = 0
        rangeView.maxValue = 20000
        rangeView.selectedMinValue = 0
        rangeView.selectedMaxValue = 20000
    }
}
