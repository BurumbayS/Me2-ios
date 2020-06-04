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
    var newChatRoom: Room!
    var roomUUIDToOpenFirst: Dynamic<String> = Dynamic("")
    
    var searchResults = [Room]()
    var searchActivated = false
    
    func getChatList(completion: ResponseBlock?) {
        Alamofire.request(roomURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    self.chatsList = []
                    for item in json["data"]["results"].arrayValue {
                        let room = Room(json: item)
                        if room.type == .LIVE {
                            self.chatsList.append(Room(json: item))
                        } else
                        if room.lastMessage.uuid != "" {
                            self.chatsList.append(Room(json: item))
                        }
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
                    self.newChatRoom = Room(json: json["data"])
                    
                    completion?(.ok, "")
                    
                case .failure(_ ):
                    print(JSON(response.data as Any))
                    completion?(.fail, "")
                }
        }
    }
    
    func getRoomInfo(with uuid: String, completion: ResponseBlock?) {
        let url = roomURL + "\(uuid)/"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { [weak self] (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    self?.newChatRoom = Room(json: json["data"])
                    
                    completion?(.ok, "")
                    
                case .failure(_ ):
                    print(JSON(response.data as Any))
                    completion?(.fail, "")
                }
        }
    }
    
    func searchChat(with substr: String, completion: VoidBlock?) {
        searchResults = []
        
        chatsList.forEach { (room) in
            if room.name.contains(substr) {
                searchResults.append(room)
            }
        }
        
        completion?()
    }
    
    let roomURL = Network.chat + "/room/"
}
