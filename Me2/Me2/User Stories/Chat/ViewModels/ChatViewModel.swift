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
    
    var onNewMessage: ((Message) -> ())?
    var onMessagesLoad: VoidBlock?
    
    init(room: Room) {
        self.room = room
    }
    
    func setUpConnection() {
        adapter = ChatAdapter(uuid: room.uuid, onNewMessage: { [weak self] (message) in
//            self?.messages.append(message)
            self?.onNewMessage?(message)
        })
        
        adapter.setUpConnection()
    }
    
    func abortConnection() {
       adapter.abortConnection()
    }
    
    func sendMessage(with text: String) {
        adapter.sendMessage(with: text)
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
        
        if room.type == .LIVE && !message.isMine() {
            let height = message.height + LiveChatMessageCollectionViewCell.usernameLabelHeight
            return height
        }
        
        return message.height
    }
    
    let messagesListURL = Network.chat + "/message/?limit=20&"
}
