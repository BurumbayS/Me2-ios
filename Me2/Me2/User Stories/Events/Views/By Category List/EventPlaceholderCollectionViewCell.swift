//
//  EventPlaceholderCollectionViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/24/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import ShimmerSwift

class EventPlaceholderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var shimmeringView: ShimmeringView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.drawShadow(color: UIColor.black.cgColor, forOpacity: 0.3, forOffset: CGSize(width: 0, height: 0), radius: 5)
        self.backgroundColor = .clear
        
        let shimmerView = ShimmeringView(frame: self.contentView.bounds)
        self.addSubview(shimmerView)
        
        shimmerView.contentView = self.contentView
        shimmerView.isShimmering = true
    }
}
