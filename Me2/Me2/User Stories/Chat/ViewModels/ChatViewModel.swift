//
//  ChatViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/29/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Starscream
import SwiftyJSON
import Alamofire

class ChatViewModel {
    var messages = [Message]()
    
    let room: Room
    var loadingMessages = false
    
    var adapter: ChatAdapter!
    
    var onNewMessage: (([Message]) -> ())?
    var onPrevMessagesLoad: (([Message], [Message]) -> ())?
    
    init(room: Room) {
        self.room = room
    }
    
    func setUpConnection() {
        adapter = ChatAdapter(uuid: room.uuid, onNewMessage: { [weak self] (message) in
            self?.messages.append(message)
            self?.onNewMessage?(self?.messages ?? [])
        })
        
        adapter.setUpConnection()
    }
    
    func abortConnection() {
       adapter.abortConnection()
    }
    
    func sendMessage(ofType type: MessageType, text: String = "", image: UIImage? = nil, video: Data? = nil, audio: Data? = nil, data: JSON = JSON()) {
        let str = "{\n  \"location\" : {\n    \"address1\" : \"Розыбакиева, 247 блок 3, 1 этаж\",\n    \"address2\" : \"Бостандыкский район, Алматы, 050060\",\n    \"latitude\" : 43.203876999999999,\n    \"longitude\" : 76.898396000000005\n  },\n  \"place_type\" : {\n    \"tag_type\" : \"PLACE_TYPE\",\n    \"name\" : \"Кофейня\",\n    \"id\" : 5\n  },\n  \"id\" : 7,\n  \"logo\" : \"https:\\/\\/api.me2.aiba.kz\\/media\\/place\\/None\\/logo\\/kr1v0jxmx5ndandmi3u08icp0.png\",\n  \"rating\" : 5,\n  \"is_favourite\" : true,\n  \"name\" : \"Traveler\'s Coffee на Розыбакиева\",\n  \"working_hours\" : {\n    \"saturday\" : {\n      \"start\" : \"08:00\",\n      \"day_and_night\" : false,\n      \"end_s\" : 0,\n      \"start_s\" : 28800,\n      \"works\" : true,\n      \"end\" : \"00:00\"\n    },\n    \"friday\" : {\n      \"start\" : \"08:00\",\n      \"day_and_night\" : false,\n      \"end_s\" : 0,\n      \"start_s\" : 28800,\n      \"works\" : true,\n      \"end\" : \"00:00\"\n    },\n    \"thursday\" : {\n      \"start_s\" : 28800,\n      \"end\" : \"00:00\",\n      \"end_s\" : 0,\n      \"works\" : true,\n      \"day_and_night\" : false,\n      \"start\" : \"08:00\"\n    },\n    \"tuesday\" : {\n      \"start_s\" : 28800,\n      \"end\" : \"00:00\",\n      \"end_s\" : 0,\n      \"works\" : true,\n      \"day_and_night\" : false,\n      \"start\" : \"08:00\"\n    },\n    \"sunday\" : {\n      \"start_s\" : 28800,\n      \"end\" : \"00:00\",\n      \"end_s\" : 0,\n      \"works\" : false,\n      \"day_and_night\" : false,\n      \"start\" : \"08:00\"\n    },\n    \"monday\" : {\n      \"start\" : \"08:00\",\n      \"day_and_night\" : false,\n      \"end_s\" : 0,\n      \"start_s\" : 28800,\n      \"works\" : true,\n      \"end\" : \"00:00\"\n    },\n    \"wednesday\" : {\n      \"start\" : \"08:00\",\n      \"day_and_night\" : false,\n      \"end_s\" : 0,\n      \"start_s\" : 28800,\n      \"works\" : true,\n      \"end\" : \"00:00\"\n    }\n  },\n  \"reg_status\" : \"REGISTERED\",\n  \"room_info\" : {\n    \"uuid\" : \"bfb68cf4-21cc-4664-aee1-3971cb6d7b75\",\n    \"users_count\" : 0,\n    \"avatars\" : [\n\n    ]\n  }\n}"
        let place = JSON(parseJSON: str)
//        let data: JSON = ["place": place]
        
        switch type {
        case .TEXT:
            
            adapter.sendMessage(type: .TEXT, text: text)
            
        case .IMAGE:
            
            guard let image = image else { break }
            uploadMedia(ofType: .IMAGE, data: image.jpegData(compressionQuality: 0.5))
            
        default:
            break
        }
    }
    
    func loadMessages(completion: ResponseBlock?) {
        if (!loadingMessages) { loadingMessages = true } else { return }
        
        var url = messagesListURL + "room=\(room.uuid)"
        
        if messages.count > 0 {
            url += "&created_at=\(messages[0].createdAt)"
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { [weak self] (response) in
                switch response.result {
                case .success(let value):
                    
                    self?.loadingMessages = false
                    
                    let json = JSON(value)
                    
                    var messages = [Message]()
                    for item in json["data"]["results"].arrayValue.reversed() {
                        messages.append(Message(json: item))
                    }
                    
                    self?.messages = messages + ((self?.messages) ?? [])
                    self?.onPrevMessagesLoad?(messages, self?.messages ?? [])
                    
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error)
                    completion?(.fail, "")
                }
        }
    }
    
    func heightForCell(at indexPath: IndexPath) -> CGFloat {
        let message = messages[indexPath.row]
        
        if let place = message.place, place.id != 0 {
            return 200
        }
        
        if room.type == .LIVE && !message.isMine() {
            let height = message.height + LiveChatMessageCollectionViewCell.usernameLabelHeight
            return height
        }
        
        return message.height
    }
    
    private func uploadMedia(ofType type: MessageType, data: Data?) {
        guard let data = data else { return }
        
        var fileName = ""
        var mimeType = ""
        
        switch type {
        case .IMAGE:
            fileName = "image.jpeg"
            mimeType = "image/jpeg"
        default:
            break
        }
        
        Alamofire.upload(multipartFormData: { [weak self] (multipartFormData) in
            multipartFormData.append(data, withName: "file", fileName: fileName, mimeType: mimeType)
            multipartFormData.append("\(self?.room.uuid ?? "")".data(using: String.Encoding.utf8)!, withName: "room")
            
        }, usingThreshold: UInt64.init(), to: uploadMediaURL, method: .post, headers: Network.getAuthorizedHeaders()) { (result) in
            switch result{
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    let json = JSON(response.data as Any)
                    print(json)
                    
                    let media = json["data"]["id"].intValue
                    self.adapter.sendMessage(type: .IMAGE, file: media)
//                    completion?(json["data"]["id"].intValue)
                    
                }
                
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
//                completion?(0)
            }
        }
    }
    
    let messagesListURL = Network.chat + "/message/?limit=20&"
    let uploadMediaURL = Network.chat + "/media_file/"
}
