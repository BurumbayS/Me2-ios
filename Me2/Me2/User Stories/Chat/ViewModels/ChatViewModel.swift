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
    
    var lastMessage = ""
    
    var socket: WebSocket!
    
    init() {
        messages = Dynamic([])
//        var message = Message(text: "Hello world! My name is Sanzhar", time: "", type: .partner)
//        messages.append(message)
//        message = Message(text: "Hi, Sanzhar! How are you?", time: "", type: .my)
//        messages.append(message)
//        message = Message(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", time: "", type: .partner)
//        messages.append(message)
//        message = Message(text: "Hello world! My name is Sanzhar", time: "", type: .partner)
//        messages.append(message)
//        message = Message(text: "Hello world! My name is Sanzhar", time: "", type: .partner)
//        messages.append(message)
//        message = Message(text: "Hi, Sanzhar! How are you?", time: "", type: .my)
//        messages.append(message)
//        message = Message(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", time: "", type: .partner)
//        messages.append(message)
//        message = Message(text: "Hello world! My name is Sanzhar", time: "", type: .partner)
//        messages.append(message)
//        message = Message(text: "Hello world! My name is Sanzhar", time: "", type: .partner)
//        messages.append(message)
//        message = Message(text: "Hi, Sanzhar! How are you?", time: "", type: .my)
//        messages.append(message)
//        message = Message(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", time: "", type: .partner)
//        messages.append(message)
//        message = Message(text: "Hello world! My name is Sanzhar", time: "", type: .partner)
//        messages.append(message)
    }
    
    func setUpConnection() {
        socket = WebSocket(url: URL(string: "ws://api.me2.aiba.kz/ws/3db9333f-e2de-4c98-b1f4-a716753c4aa0/")!)
        socket.delegate = self
        socket.connect()
    }
    
    func sendMessage(with text: String) {
        lastMessage = text
        
        let message = Message(text: text, time: "", type: .my)
        messages.value.append(message)
        
        let json: JSON = ["message": text, "message_type" : "TEXT"]
    
        if let message = json.rawString() {
            socket.write(string: message)
        }
    }
}

extension ChatViewModel: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
         print("websocket is disconnected: \(error?.localizedDescription)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let json = JSON(parseJSON: text)
        
        guard lastMessage != json["message"]["message"].stringValue else { return }
        
        let message = Message(text: json["message"]["message"].stringValue, time: "", type: .partner)
        messages.value.append(message)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("got some data: \(data.count)")
    }
}
