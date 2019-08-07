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
    
    func addUnderline(with color : UIColor, and frame : CGSize) {
        let border = CALayer()
        border.borderColor = color.cgColor
        border.borderWidth = 0.5
        border.frame = CGRect(x: 0, y: frame.height - 0.5, width: frame.width, height: frame.height)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
