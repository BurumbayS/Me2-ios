//
//  Tag.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/28/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import SwiftyJSON

class Tag {
    let id: Int
    let name: String
    let tag_type: String
    
    init(json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        tag_type = json["tag_type"].stringValue
    }
}
