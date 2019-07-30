//
//  CharacterExtension.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 7/30/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

extension Character {
    func isBackSpace() -> Bool {
        let char = String(self).cString(using: String.Encoding.utf8)
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            return true
        }
        
        return false
    }
}
