//
//  ConfirmPinCodeViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 7/30/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum CodeConfirmationType {
    case onRegistrartion
    case onChange
}

class ConfirmPinCodeViewModel {
    let phoneActivationID: Int
    let confirmationType: CodeConfirmationType
    
    init(activationID : Int, confirmationType: CodeConfirmationType) {
        phoneActivationID = activationID
        self.confirmationType = confirmationType
    }
    
    func activatePhone(with smsCode: String, completion: ((RequestStatus, String) -> ())?) {
        let activateURL = Network.auth + "/\(phoneActivationID)/activate/"
        let params = ["code": smsCode]
        
        Alamofire.request(activateURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Network.getHeaders())
            .responseJSON { [weak self] (response) in
                switch response.result {
                case .success(let result):
                    
                    let json = JSON(result)
                    print(json)
                    
                    let code = json["code"].intValue
                    switch code {
                    case 0:
                        
                        let token = json["data"]["token"].stringValue
                        let id = json["data"]["user"]["id"].intValue
                        UserDefaults().set(token, forKey: UserDefaultKeys.token.rawValue)
                        UserDefaults().set(id, forKey: UserDefaultKeys.userID.rawValue)
                        UserDefaults().set(json["data"]["user"].rawString(), forKey: UserDefaultKeys.userInfo.rawValue)
                        UserDefaults().set(json["data"]["user"]["favourite_events"].rawString(), forKey: UserDefaultKeys.savedEvents.rawValue)
                        
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
}
