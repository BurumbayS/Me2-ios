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

struct MessagesSection {
    let date: String
    var messages: [Message]
}

class ChatViewModel {
    var messages = [Message]()
    var sections = [MessagesSection]()
    
    let room: Room
    var loadingMessages = false
    
    var adapter: ChatAdapter!
    
    var isFirstLaunch = true
    
    var onNewMessage: ((Message) -> ())?
    var onMessagesLoad: VoidBlock?
    var onMessageUpdate: ((Int) -> ())?
    
    var shouldWaveOnPresent = false
    
    init(room: Room, shouldWave: Bool = false) {
        self.room = room
        self.shouldWaveOnPresent = shouldWave
        
        self.configureAdapter()
    }
    
    private func configureAdapter() {
        adapter = ChatAdapter(uuid: room.uuid, onNewMessage: { [weak self] (message) in
            self?.addNewMessage(message: message)
            }, onMessageUpdate: { [weak self] (message) in
                self?.updateMessage(message: message)
        })
    }
    
    func reconnect() {
        adapter.setUpConnection(completion: nil)
    }
    
    func setUpConnection(completion: VoidBlock?) {
        adapter.setUpConnection(completion: completion)
    }
    
    func abortConnection() {
       adapter.abortConnection()
    }
    
    private func addNewMessage(message: Message) {
        onNewMessage?(message)
    }
    
    private func updateMessage(message: Message) {
        let lastSection = sections.count - 1
        if let index = sections[lastSection].messages.firstIndex(where: { message.uuid == $0.uuid }) {
            sections[lastSection].messages[index] = message
            onMessageUpdate?(index)
        }
    }
    
    func sendMessage(ofType type: MessageType, text: String = "", videoURL: URL? = nil, thumbnail: UIImage? = nil, audio: Data? = nil) {
        var messageJSON = JSON()
        
        let uuid = UUID().uuidString
        let data: JSON = ["uuid": uuid]
        
        messageJSON = ["text": text, "created_at": Date().toString(), "message_type": type.rawValue, "file" : JSON(), "data": data]
        let message = Message(json: messageJSON, status: .pending)
        
        if let image = thumbnail {
            message.file?.thumbnailImage = image
        }
        
        addNewMessage(message: message)
        
        adapter.sendMessage(message: message, videoURL: videoURL, thumbnail: thumbnail)
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
                    self?.messages.sort(by: { $0.getDateString() < $1.getDateString() })
                    self?.groupMessagesByDate(completion: completion)
                    
                case .failure(let error):
                    print(error)
                    completion?(.fail, "")
                }
        }
    }
    
    private func groupMessagesByDate(completion: ResponseBlock?) {
        var currentDate = ""
        var byDateMessages = [Message]()
        var messageSections = [MessagesSection]()
        
        for message in messages {
            if currentDate != "" && message.getDateString() != currentDate {
                let messageSection = MessagesSection(date: currentDate, messages: byDateMessages)
                messageSections.append(messageSection)
                
                currentDate = message.getDateString()
                byDateMessages = [message]
            } else {
                currentDate = message.getDateString()
                byDateMessages.append(message)
            }
        }
        
        if byDateMessages.count > 0 {
            let messageSection = MessagesSection(date: currentDate, messages: byDateMessages)
            messageSections.append(messageSection)
        }
        
        self.sections = messageSections
        
        self.onMessagesLoad?()
        completion?(.ok, "")
    }
    
    func heightForCell(at indexPath: IndexPath) -> CGFloat {
        let message = sections[indexPath.section].messages[indexPath.row]
        
        if let place = message.place, place.id != 0 {
            return 200
        }
        
        switch message.type {
        case .TEXT:
        
            if room.type == .LIVE && !message.isMine() {
                let height = message.height + LiveChatMessageCollectionViewCell.usernameLabelHeight
                return height
            }
            
            return message.height
            
        case .IMAGE, .VIDEO:
            
            return 250
            
        case .WAVE:
            
            if message.isMine() {
                return 50
            }
            
            return 110
            
        default:
            return 0
        }
    
    }
    
    let messagesListURL = Network.chat + "/message/?limit=20&"
}
