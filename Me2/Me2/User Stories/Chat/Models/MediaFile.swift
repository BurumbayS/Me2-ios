//
//  MediaFile.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/4/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import SwiftyJSON

class MediaFile {
    static let mediaFileCellID = "MediaCell"
    
    let id: Int
    let file: String
    var thumbnail: UIImage?
    
    init(json: JSON = JSON()) {
        id = json["id"].intValue
        file = json["file"].stringValue
    }

}
