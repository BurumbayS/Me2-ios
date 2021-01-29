//
//  PushNotificationsRouter.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/13/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import Foundation

enum TabRoute {
    case room
    case notifications
}

enum Tab {
    case map
    case events
    case chat
    case profile
}

class PushNotificationsRouter {
    static let shared = PushNotificationsRouter()
    
    var pushToTab = Tab.map
    var pushToRoute: TabRoute?
    var data: Any?
    
    func shouldPush(to path: String) {
        guard let url = URL(string: path) else {
            fatalError("Wrong path of chat")
        }
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let pathItems = components.path.split(separator: "/")
        
        if pathItems.contains("chat") {
            pushToTab = .chat
            
            if pathItems.contains("room") {
                pushToRoute = .room
                data = String(pathItems.first(where: { $0 != "chat" && $0 != "room"}) ?? "")
            }
        }
        
        openTab()
    }
    
    private func openTab() {
        if let tabsVC = window.rootViewController as? MainTabsViewController {
            tabsVC.openSelectedTab()
        } else {
            window.rootViewController = Storyboard.mainTabsViewController()
        }
    }
}
