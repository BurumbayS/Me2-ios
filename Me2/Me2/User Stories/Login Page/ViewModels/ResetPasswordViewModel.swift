//
//  ResetPasswordViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/11/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ResetPasswordViewModel {
    
    var phoneActivationID = 0
    
    func resetPassword(for phoneNumber: String, completion: ((RequestStatus, String) -> ())?) {
        let params = ["phone": phoneNumber.replacingOccurrences(of: " ", with: "")]
        
        Alamofire.request(resetPasswordURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Network.getHeaders())
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
    
    let resetPasswordURL = Network.auth + "/reset_password/"
}
