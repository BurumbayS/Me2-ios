//
//  Realm.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 2/6/20.
//  Copyright © 2020 AVSoft. All rights reserved.
//

import RealmSwift

class RealmAdapter {
    static let shared = try! Realm()
    
    static func write(object: Object) {
        try! shared.write {
            shared.add(object)
        }
    }
}
