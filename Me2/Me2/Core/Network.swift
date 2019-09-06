//
//  Network.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/6/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

class Network {
    static let host = "http://api.me2.aiba.kz"
    
    static func getHeaders() -> [String : String] {
        let headers = ["Content-Type" : "application/json", "Accept" : "application/json"]
        
        return headers
    }
    
    static let auth = host + "/auth/auth"
}
