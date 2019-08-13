//
//  UIViewExtensions.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 7/30/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

extension UIView {
    func roundCorners(radius : CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func makeTransparent() {
        self.alpha = 0.3
    }
    
    func makeVisible() {
        self.alpha = 1.0
    }
    
    func drawShadow(color: CGColor = UIColor.black.cgColor,
                    forOpacity opacity: Float,
                    forOffset offset: CGSize,
                    radius: CGFloat = 10) {
        layer.masksToBounds = false
        layer.shadowColor = color
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
}
