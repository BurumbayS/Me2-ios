//
//  ChatAdapter.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/7/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Starscream
import SwiftyJSON

class ChatAdapter {
    let roomUUID: String
    var socket: WebSocket!
    
    let newMessageHandler: ((Message) -> ())?
    
    init(uuid: String, onNewMessage: ((Message) -> ())?) {
        self.roomUUID = uuid
        self.newMessageHandler = onNewMessage
    }
    
    func setUpConnection() {
        guard let token = UserDefaults().object(forKey: UserDefaultKeys.token.rawValue) as? String else { return }
        socket = WebSocket(url: URL(string: "wss://api.me2.aiba.kz/ws/\(roomUUID)/?token=\(token)")!)
        socket.delegate = self
        socket.connect()
    }
    
    func abortConnection() {
        guard let socket = self.socket else { return }
        
        socket.disconnect()
    }
    
    func sendMessage(with text: String) {
        let json: JSON = ["text": text, "message_type" : "TEXT"]
        
        if let message = json.rawString() {
            socket.write(string: message)
        }
        
        newMessageHandler?(Message(json: json))
    }
}

extension ChatAdapter: WebSocketDelegate {
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
            newMessageHandler?(message)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("got some data: \(data.count)")
    }
}

