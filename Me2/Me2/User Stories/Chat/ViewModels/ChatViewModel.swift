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
    var messages: Dynamic<[Message]>
    
    let roomUUID: String
    var loadingMessages = false
    
    var socket: WebSocket!
    
    var onNewMessage: (([Message]) -> ())?
    var onPrevMessagesLoad: (([Message], [Message]) -> ())?
    
    init(uuid: String) {
        self.roomUUID = uuid
        
        messages = Dynamic([])
    }
    
    func setUpConnection() {
        guard let token = UserDefaults().object(forKey: UserDefaultKeys.token.rawValue) as? String else { return }
        socket = WebSocket(url: URL(string: "ws://api.me2.aiba.kz/ws/\(roomUUID)/?token=\(token)")!)
        socket.delegate = self
        socket.connect()
    }
    
    func abortConnection() {
        guard let socket = self.socket else { return }
        
        socket.disconnect()
    }
    
    func sendMessage(with text: String) {
        let json: JSON = ["text": text, "message_type" : "TEXT"]
        
        let message = Message(json: json)
        messages.value.append(message)
    
        if let message = json.rawString() {
            socket.write(string: message)
        }
        
        onNewMessage?(messages.value)
    }
    
    func loadMessages(completion: ResponseBlock?) {
        if (!loadingMessages) { loadingMessages = true } else { return }
        
        var url = messagesListURL + "room=\(roomUUID)"
        
        if messages.value.count > 0 {
            url += "&created_at=\(messages.value[0].createdAt)"
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { [weak self] (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    var messages = [Message]()
                    for item in json["data"]["results"].arrayValue.reversed() {
                        messages.append(Message(json: item))
                    }
                    
                    self?.messages.value = messages + ((self?.messages.value) ?? [])
                    self?.onPrevMessagesLoad?(messages, self?.messages.value ?? [])
                    
                    self?.loadingMessages = false
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error)
                    completion?(.fail, "")
                }
        }
    }
    
    let messagesListURL = Network.chat + "/message/?limit=20&"
}

extension ChatViewModel: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket is disconnected: \(error?.localizedDescription ?? "")")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let json = JSON(parseJSON: text)
        
        let message = Message(json: json["message"])
        if !message.isMine() {
            messages.value.append(message)
            onNewMessage?(messages.value)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("got some data: \(data.count)")
    }
}
