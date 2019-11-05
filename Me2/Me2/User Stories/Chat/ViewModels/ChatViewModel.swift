//
//  ChatViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/29/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Starscream
import SwiftyJSON

class ChatViewModel {
    var messages: Dynamic<[Message]>
    
    let roomUUID: String
    
    var socket: WebSocket!
    
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
    
    func sendMessage(with text: String) {
        let json: JSON = ["text": text, "message_type" : "TEXT"]
        
        let message = Message(json: json)
        messages.value.append(message)
    
        if let message = json.rawString() {
            socket.write(string: message)
        }
    }
    
    func loadMessages() {
//        var message = Message(text: "Hello world! My name is Sanzhar", time: "", type: .partner)
//        messages.append(message)
//        message = Message(text: "Hi, Sanzhar! How are you?", time: "", type: .my)
//        messages.append(message)
//        message = Message(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", time: "", type: .partner)
//        messages.append(message)
//        message = Message(text: "Hello world! My name is Sanzhar", time: "", type: .partner)
//        messages.append(message)
    }
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
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("got some data: \(data.count)")
    }
}
