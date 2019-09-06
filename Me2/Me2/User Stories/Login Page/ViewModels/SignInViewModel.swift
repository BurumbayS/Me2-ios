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

    func signIn(with username: String, and password: String) {
        let params = ["username": username, "password": password]
        
        Alamofire.request(authenticateURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Network.getHeaders())
            .responseJSON { (response) in
                switch response.result {
                case .success(let result):
                    
                    let json = JSON(result)
                    let code = json["code"].intValue
                    switch code {
                    case 0:
                        print("ok")
                    case 1:
                        let message = json["message"].stringValue
                        print(message)
                    default:
                        break
                    }
                    
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    let authenticateURL = Network.auth + "/authenticate/"
    let register = Network.auth + "/register"
    let reset_password = Network.auth + "/reset_password"
    let social = Network.auth + "/social"
//    let activate = Network.auth + "/\()/activate"
}
