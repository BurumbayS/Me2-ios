//
//  ComplainViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/18/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ComplainViewModel {
    let userID: Int
    
    init(userID: Int) {
        self.userID = userID
    }
    
    func complainToUser(withText text: String, completion: ResponseBlock?) {
        let url = Network.core + "/user_complaint/"
        let params = ["to_user": userID, "text": text] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    
                    if json["code"].intValue == 0 {
                        completion?(.ok, "")
                    } else {
                        completion?(.error, json["message"].stringValue)
                    }
                    
                case .failure(_):
                    let json = JSON(response.data as Any)
                    print(json)
                    completion?(.fail, json["message"].stringValue)
                }
        }
    }
}
