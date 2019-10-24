//
//  Constants.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/28/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class Constants {
    static let shared = Constants()
    
    //minimal allowable content size for tab section in place profile (minus the top bar and header)
    var minContentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 150)
}
