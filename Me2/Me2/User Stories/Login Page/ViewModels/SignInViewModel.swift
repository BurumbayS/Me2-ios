//
//  SignInViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/6/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SignInViewModel {
    
    func signIn(with socialMedia: SocialMediaType, and token: String, completion: ((RequestStatus, String) -> ())?) {
        let params = ["access_token" : token, "social_type" : socialMedia.rawValue]
        
        Alamofire.request(socialAuthURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Network.getHeaders())
            .responseJSON { (response) in
                switch response.result {
                case .success(let result):
                    
                    let json = JSON(result)
                    let code = json["code"].intValue
                    switch code {
                    case 0:
                        
                        let token = json["data"]["token"].stringValue
                        let id = json["data"]["user"]["id"].intValue
                        UserDefaults().set(token, forKey: UserDefaultKeys.token.rawValue)
                        UserDefaults().set(id, forKey: UserDefaultKeys.userID.rawValue)
                        
                        completion?(.ok, "")
                        
                    case 1:
                        
                        let message = json["message"].stringValue
                        completion?(.error, message)
                        
                    default:
                        break
                    }
                    
                case .failure(let error):
                    print(error)
                    completion?(.fail, "")
                }
        }
    }
    
    func signIn(with username: String, and password: String, completion: ((RequestStatus, String) -> ())?) {
        let params = ["username": username, "password": password]
        
        Alamofire.request(authenticateURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Network.getHeaders())
            .responseJSON { (response) in
                switch response.result {
                case .success(let result):
                    
                    let json = JSON(result)
                    let code = json["code"].intValue
                    switch code {
                    case 0:
                        
                        let token = json["data"]["token"].stringValue
                        let id = json["data"]["user"]["id"].intValue
                        UserDefaults().set(token, forKey: UserDefaultKeys.token.rawValue)
                        UserDefaults().set(id, forKey: UserDefaultKeys.userID.rawValue)
                        
                        completion?(.ok, "")
                        
                    case 1:
                        
                        let message = json["message"].stringValue
                        completion?(.error, message)
                        
                    default:
                        break
                    }
                    
                case .failure(let error):
                    print(error)
                    completion?(.fail, "")
                }
        }
    }
    
    let authenticateURL = Network.auth + "/authenticate/"
    let socialAuthURL = Network.auth + "/social/"
}
