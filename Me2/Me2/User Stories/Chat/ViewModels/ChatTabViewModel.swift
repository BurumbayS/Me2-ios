//
//  ChatTabViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/5/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

enum ContaierScreen {
    case chatList
    case liveChat
}

class ChatTabViewModel {
    var currentScreen = ContaierScreen.chatList
}
