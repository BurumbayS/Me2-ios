//
//  SignUpViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/7/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SignUpViewModel {
    
    var phoneActivationID = 0
    
    func signUp(with phoneNumber: String, completion: ((RequestStatus, String) -> ())?) {
        let params = ["phone": phoneNumber.replacingOccurrences(of: " ", with: "")]
        
        Alamofire.request(registerURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Network.getHeaders())
            .responseJSON { [weak self] (response) in
                switch response.result {
                case .success(let result):
                    
                    let json = JSON(result)
                    print(json)
                    
                    let code = json["code"].intValue
                    switch code {
                    case 0:
                        
                        self?.phoneActivationID = json["data"]["activation"]["id"].intValue
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
    
    let registerURL = Network.auth + "/register/"
}
