//
//  MapSearchFilterTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/13/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import RangeSeekSlider

class SliderRange {
    var low: CGFloat
    var high: CGFloat
    
    init(low: CGFloat, high: CGFloat) {
        self.low = low
        self.high = high
    }
}

class MapSearchFilterTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var sliderView: RangeSeekSlider!
    @IBOutlet weak var sliderHeight: NSLayoutConstraint!
    
    var sliderRange: SliderRange!
    
    func configure(with title: String, filterType: FilterType, range: SliderRange = SliderRange(low: 0, high: 0), selected: Bool = false) {
        titleLabel.text = title
        checkImageView.isHidden = true
        
        switch filterType {
        case .slider:
            if title == "Бизнес-ланч" {
                sliderView.minValue = 700
                sliderView.maxValue = 3000
            } else {
                sliderView.minValue = 1000
                sliderView.maxValue = 50000
            }
            showSlider(with: range)
        default:
            hideSlider()
        }
        
        if selected {
            titleLabel.textColor = Color.blue
            checkImageView.isHidden = false
        } else {
            titleLabel.textColor = .darkGray
            checkImageView.isHidden = true
        }
    }
    
    private func showSlider(with range: SliderRange) {
        sliderRange = range
        
        sliderView.addTarget(self, action: #selector(sliderValueChanged), for: .allEvents)
        
        sliderView.selectedMinValue = range.low
        sliderView.selectedMaxValue = range.high
        sliderView.maxLabelFont = UIFont(name: "Roboto-Medium", size: 13)!
        sliderView.minLabelFont = UIFont(name: "Roboto-Medium", size: 13)!
        
        sliderView.isHidden = false
        
        sliderHeight.constant = 50
        self.layoutIfNeeded()
    }
    
    private func hideSlider() {
        sliderHeight.constant = 0
        sliderView.isHidden = true
        self.layoutIfNeeded()
    }
    
    @objc private func sliderValueChanged() {
        sliderRange.low = sliderView.selectedMinValue
        sliderRange.high = sliderView.selectedMaxValue
    }
}
