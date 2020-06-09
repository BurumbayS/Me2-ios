//
//  UIButtonExtensions.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 6/9/20.
//  Copyright © 2020 AVSoft. All rights reserved.
//

import Foundation

extension UIButton {
    func enable() {
        self.isEnabled = true
        self.alpha = 1.0
    }
    func disable() {
        self.isEnabled = false
        self.alpha = 0.2
    }
}
