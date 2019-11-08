//
//  ChatTabViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/5/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ChatTabViewModel {
    
    var chatsList = [Room]()
    
    func getChatList(completion: ResponseBlock?) {
        Alamofire.request(roomURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    for item in json["data"]["results"].arrayValue {
                        self.chatsList.append(Room(json: item))
                    }
                    
                    completion?(.ok, "")
                    
                case .failure(_ ):
                    print(JSON(response.data as Any))
                    completion?(.fail, "")
                }
        }
    }
    
    func openNewChat(withUser id: Int, completion: ResponseBlock?) {
        let params = ["room_type": "SIMPLE", "participants": [id]] as [String: Any]
        
        Alamofire.request(roomURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    
                    completion?(.ok, "")
                    
                case .failure(_ ):
                    print(JSON(response.data as Any))
                    completion?(.fail, "")
                }
        }
    }
    
    let roomURL = Network.chat + "/room/"
}
