//
//  ChangePhoneViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/15/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ChangePhoneViewModel {
    let phonePattern = "+# (###) ###-####"
    
    let userPhone: String
    var activationID = 0
    
    
    init() {
        userPhone = ""
    }
    
    func updatePhone(with newPhone: String, completion: @escaping StatusBlock<Any, String>) {
        let phone = newPhone.applyPatternOnNumbers(pattern: "+###########", replacmentCharacter: "#")
        
        let params: [String : String] = ["phone": phone]
        
        Alamofire.request(updatePhoneURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { [weak self] (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    self?.activationID = json["data"]["activation"]["id"].intValue
                    
                    completion(.success(json))
                    
                case .failure(_ ):
                    guard let data = response.data,
                          let errorMessage = JSON.init(data).dictionaryValue["message"]?.stringValue else {
                        return
                    }
                    completion(.fail(errorMessage))
                }
        }
    }
    
    let updatePhoneURL = Network.user + "/change_phone/"
}

enum Status<T,R> {
    case success(T)
    case fail(R)
    
}
