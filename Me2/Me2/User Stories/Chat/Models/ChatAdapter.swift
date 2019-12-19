//
//  ChatAdapter.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/7/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Starscream
import SwiftyJSON
import Alamofire
import AVKit

class ChatAdapter {
    let roomUUID: String
    var socket: WebSocket!
    
    let newMessageHandler: ((Message) -> ())?
    let messageStatusUpdateHandler: ((Message) -> ())?
    
    var connectionCompletion: VoidBlock?
    
    var forcedDisconnect = false
    
    init(uuid: String, onNewMessage: ((Message) -> ())?, onMessageUpdate: ((Message) -> ())?) {
        self.roomUUID = uuid
        self.newMessageHandler = onNewMessage
        self.messageStatusUpdateHandler = onMessageUpdate
    }
    
    func setUpConnection(completion: VoidBlock?) {
        self.connectionCompletion = completion
        
        guard let token = UserDefaults().object(forKey: UserDefaultKeys.token.rawValue) as? String else { return }
        socket = WebSocket(url: URL(string: "wss://api.me2.aiba.kz/ws/\(roomUUID)/?token=\(token)")!)
        socket.delegate = self
        
        forcedDisconnect = false
        socket.connect()
    }
    
    func abortConnection() {
        guard let socket = self.socket else { return }
        
        forcedDisconnect = true
        socket.disconnect()
    }
    
    func sendMessage(message: Message, videoURL: URL? = nil, thumbnail: UIImage? = nil) {
        let data: JSON = ["uuid": message.uuid as Any]
        
        switch message.type {
        case .TEXT, .WAVE:
            sendDefaultMessage(type: message.type, text: message.text, data: data)
        case .IMAGE, .VIDEO:
            sendMediaMessage(messageType: message.type, videoURL: videoURL, thumbnail: thumbnail, data: data)
        default:
            break
        }
    }
    
    private func sendMessage(json: JSON) {
        if let message = json.rawString() {
            socket.write(string: message)
        }
    }
    
    private func sendDefaultMessage(type: MessageType, text: String, data: JSON) {
        var json = JSON()
        json = ["text": text, "message_type" : type.rawValue, "data": data]
        
        sendMessage(json: json)
    }
    
    private func sendMediaMessage(messageType: MessageType, videoURL: URL?, thumbnail: UIImage?, data: JSON) {
        
        switch messageType {
        case .IMAGE:
            
            if let image = thumbnail {
                let mediaData = image.jpegData(compressionQuality: 0.5)
                callUploadMedia(ofType: .IMAGE, media: mediaData, additionalData: data)
            }
            
        case .VIDEO:
            
            VideoHelper.encodeVideo(videoUrl: videoURL) { [weak self] (encodedVideoURL) in
                guard let url = encodedVideoURL else { return }
                
                let mediaData = try? Data(contentsOf: url)
                self?.callUploadMedia(ofType: .VIDEO, media: mediaData, additionalData: data)
            }
            
        default:
            break
        }

    }
    
    private func callUploadMedia(ofType type: MessageType, media: Data?, additionalData: JSON) {
        guard let mediaData = media else { return }
        
        uploadMedia(ofType: type, data: mediaData) { (status, mediaID) in
            switch status {
            case .ok:
                
                let json: JSON = ["text": "", "message_type" : type.rawValue, "file": mediaID, "data": additionalData]
                self.sendMessage(json: json)
                
            default:
                break
            }
        }
    }
    
    private func uploadMedia(ofType type: MessageType, data: Data, completion: ((RequestStatus, Int) -> ())?) {
        let uploadMediaURL = Network.chat + "/media_file/"
        
        var fileName = ""
        var mimeType = ""
        
        switch type {
        case .IMAGE:
            fileName = "image.jpeg"
            mimeType = "image/jpeg"
        case .VIDEO:
            fileName = "video.mp4"
            mimeType = "video/mp4"
        default:
            break
        }
        
        Alamofire.upload(multipartFormData: { [weak self] (multipartFormData) in
            multipartFormData.append(data, withName: "file", fileName: fileName, mimeType: mimeType)
            multipartFormData.append("\(self?.roomUUID ?? "")".data(using: String.Encoding.utf8)!, withName: "room")
            
        }, usingThreshold: UInt64.init(), to: uploadMediaURL, method: .post, headers: Network.getAuthorizedHeaders()) { (result) in
            switch result{
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    let json = JSON(response.data as Any)
                    let mediaID = json["data"]["id"].intValue
                    completion?(.ok, mediaID)
                    
                }
                
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completion?(.fail, 0)
            }
        }
    }
}

extension ChatAdapter: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        connectionCompletion?()
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if !forcedDisconnect {
            setUpConnection(completion: nil)
        }
        print("websocket is disconnected: \(error?.localizedDescription ?? "")")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let json = JSON(parseJSON: text)
        
        let message = Message(json: json["message"])
        
        if message.isMine() {
            message.status = .sended
            messageStatusUpdateHandler?(message)
        } else {
            newMessageHandler?(message)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("got some data: \(data.count)")
    }
}

