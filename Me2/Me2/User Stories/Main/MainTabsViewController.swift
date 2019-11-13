//
//  MainTabsViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/1/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class MainTabsViewController: UITabBarController {
    
    let tabs = [Tab.map, .events, .chat, .profile]
    
    private let mapTabViewController : UIViewController = {
        let vc = Storyboard.mapViewController()
        let image = UIImage(named: "map_icon")
        let selectedImage = UIImage(named: "map_icon_selected")
        let tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        vc.tabBarItem = tabBarItem
        return vc
    }()
    
    private let eventsTabViewController : UINavigationController = {
        let vc = Storyboard.eventsTabViewController() as! UINavigationController
        let image = UIImage(named: "events_icon")
        let selectedImage = UIImage(named: "events_icon_selected")
        let tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        vc.tabBarItem = tabBarItem
        return vc
    }()
    
    private let chatTabViewController : UINavigationController = {
        let vc = Storyboard.chatTabViewController() as! UINavigationController
        let image = UIImage(named: "chat_icon")
        let selectedImage = UIImage(named: "chat_icon_selected")
        let tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        vc.tabBarItem = tabBarItem
        return vc
    }()
    
    private let profileTabViewController : UINavigationController = {
        let vc = Storyboard.userProfileViewController() as! UINavigationController
        let image = UIImage(named: "profile_icon")
        let selectedImage = UIImage(named: "profile_icon_selected")
        let tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        vc.tabBarItem = tabBarItem
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewControllers = [mapTabViewController,
                               eventsTabViewController,
                               chatTabViewController,
                               profileTabViewController]
        self.setViewControllers(viewControllers, animated: true)
        openSelectedTab()
    }
    
    func openSelectedTab() {
        let index = tabs.firstIndex(of: PushNotificationsRouter.shared.pushToTab)
        self.selectedIndex = index ?? 0
        
        switch PushNotificationsRouter.shared.pushToTab {
        case .chat:
            if let data = PushNotificationsRouter.shared.data as? String {
                let vc = chatTabViewController.viewControllers[0] as! ChatTabViewController
                vc.viewModel.roomUUIDToOpenFirst = data
            }
        default:
            break;
        }
        
        PushNotificationsRouter.shared.pushToTab = .map
    }
}
