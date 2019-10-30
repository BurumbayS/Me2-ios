//
//  ChatViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/29/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

class ChatViewModel {
    var messages = [Message]()
    
    init() {
        var message = Message(text: "Hello world! My name is Sanzhar", time: "", type: .partner)
        messages.append(message)
        message = Message(text: "Hi, Sanzhar! How are you?", time: "", type: .my)
        messages.append(message)
        message = Message(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", time: "", type: .partner)
        messages.append(message)
        message = Message(text: "Hello world! My name is Sanzhar", time: "", type: .partner)
        messages.append(message)
        message = Message(text: "Hello world! My name is Sanzhar", time: "", type: .partner)
        messages.append(message)
        message = Message(text: "Hi, Sanzhar! How are you?", time: "", type: .my)
        messages.append(message)
        message = Message(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", time: "", type: .partner)
        messages.append(message)
        message = Message(text: "Hello world! My name is Sanzhar", time: "", type: .partner)
        messages.append(message)
        message = Message(text: "Hello world! My name is Sanzhar", time: "", type: .partner)
        messages.append(message)
        message = Message(text: "Hi, Sanzhar! How are you?", time: "", type: .my)
        messages.append(message)
        message = Message(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", time: "", type: .partner)
        messages.append(message)
        message = Message(text: "Hello world! My name is Sanzhar", time: "", type: .partner)
        messages.append(message)
    }
}
