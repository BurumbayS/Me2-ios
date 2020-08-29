//
//  ChangePassViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/11/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ChangePassViewModel {
    func updatePassword(password: String, with newPass: String, completion: ResponseBlock?) {
        let params = ["old_password": password, "new_password": newPass]
        
        Alamofire.request(updatePassURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    switch json["code"].intValue{
                    case 0:
                        completion?(.ok, "")
                    case 1:
                        completion?(.error, json["message"].stringValue)
                    default:
                        break
                    }
                    
                case .failure( _):
                    let json = JSON(response.data as Any)
                    print(json)
                    completion?(.fail, json["message"].stringValue)
                }
        }
    }
    
    let updatePassURL = Network.user + "/change_password/"
}
