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
    var onMessageUpdate: ((Int) -> ())?
    var onPrevMessagesLoad: (([Message], [Message]) -> ())?
    
    init(room: Room) {
        self.room = room
        
        self.configureAdapter()
    }
    
    private func configureAdapter() {
        adapter = ChatAdapter(uuid: room.uuid, onNewMessage: { [weak self] (message) in
            self?.addNewMessage(message: message)
            }, onMessageUpdate: { [weak self] (message) in
                self?.updateMessage(message: message)
        })
    }
    
    func setUpConnection() {
        adapter.setUpConnection()
    }
    
    func abortConnection() {
       adapter.abortConnection()
    }
    
    private func addNewMessage(message: Message) {
        messages.append(message)
        onNewMessage?(messages)
    }
    
    private func updateMessage(message: Message) {
        if let index = messages.firstIndex(where: { message.uuid == $0.uuid }) {
            self.messages[index] = message
            onMessageUpdate?(index)
        }
    }
    
    func sendMessage(ofType type: MessageType, text: String = "", mediaData: Data? = nil, thumbnail: UIImage? = nil, audio: Data? = nil) {
        var messageJSON = JSON()
        
        let uuid = UUID().uuidString
        let data: JSON = ["uuid": uuid]
        
        messageJSON = ["text": text, "message_type": type.rawValue, "file" : JSON(), "data": data]
        let message = Message(json: messageJSON, status: .pending)
        
        if let image = thumbnail {
            message.file?.thumbnail = image
        }
        
        addNewMessage(message: message)
        adapter.sendMessage(message: message, mediaData: mediaData)
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
//                    print(json)
                    
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
        
//        if let place = message.place, place.id != 0 {
//            return 200
//        }
        
        switch message.type {
        case .TEXT:
        
            if room.type == .LIVE && !message.isMine() {
                let height = message.height + LiveChatMessageCollectionViewCell.usernameLabelHeight
                return height
            }
            
            return message.height
            
        case .IMAGE:
            
            return 200
            
        default:
            return 0
        }
    
    }
    
    let messagesListURL = Network.chat + "/message/?limit=20&"
}
