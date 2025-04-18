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
    
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {        
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(encodedOffset: index)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    
    func isBackspace() -> Bool {
        if let char = self.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        
        return false
    }

    var localized: String {
        NSLocalizedString(self, comment: self)
    }
    

    func date(by format:DateFormat = .reviewDate ) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = format.dateFormat
        return dateFormatter.date(from: self)
    }
}

enum DateFormat {
    case reviewDate
    case reviewDateDisplay
    case custom(format: String)
    
    var dateFormat: String {
        switch self {
        case .reviewDate:
            return "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        case .reviewDateDisplay:
            return "yyyy.MM.dd HH:mm"
        case .custom(format: let format):
            return format
        }
    }
}
