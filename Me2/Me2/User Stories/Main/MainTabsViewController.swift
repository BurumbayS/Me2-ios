//
//  MainTabsViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/1/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class MainTabsViewController: UITabBarController {
    
    private let mapViewController : UIViewController = {
        let vc = Storyboard.mapViewController()
        let image = UIImage(named: "map_icon")
        let selectedImage = UIImage(named: "map_icon_selected")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewControllers = [mapViewController,
                               chatTabViewController]
        self.setViewControllers(viewControllers, animated: true)
    }
}
