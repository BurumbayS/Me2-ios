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
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat, size : CGRect) {
        let path = UIBezierPath(roundedRect: size, byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat, height : CGFloat, width: CGFloat) {
        
        let border = CALayer();
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x:0, y: height - thickness, width: width, height:thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x:0, y: 0, width: thickness, height: height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: width - thickness, y: 0, width: thickness, height : height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.layer.addSublayer(border)
    }
}
