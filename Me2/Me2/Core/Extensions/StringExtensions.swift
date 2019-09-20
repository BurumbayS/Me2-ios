//
//  UIStringExtensions.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/18/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

extension String {
    
    func getWidth(with font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: fontAttributes)
        return size.width
    }
    
    func getHeight(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
}
