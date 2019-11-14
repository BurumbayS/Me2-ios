//
//  Network.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/6/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

enum RequestStatus {
    case ok
    case error
    case fail
}

class Network {
    static let host = "https://api.me2.aiba.kz"
    
    static func getHeaders() -> [String : String] {
        let headers = ["Content-Type" : "application/json", "Accept" : "application/json"]
        
        return headers
    }
    
    static func getAuthorizedHeaders() -> [String: String] {
        let token = UserDefaults().object(forKey: UserDefaultKeys.token.rawValue) as! String
        let headers = ["Content-Type" : "application/json", "Accept" : "application/json", "Authorization" : "JWT \(token)"]
        
        return headers
    }
    
    static let auth = host + "/auth/auth"
    static let user = host + "/auth/user"
    static let core = host + "/core"
    static let chat = host + "/chat"
}
