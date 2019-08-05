//
//  ChatTabViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/3/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class ChatTabViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var chatsButton: UIButton!
    @IBOutlet weak var liveButton: UIButton!
    
    let chatsListVC = Storyboard.chatsListViewController()
    let liveChatVC = Storyboard.liveChatViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpContainerView()
    }
    
    private func setUpContainerView() {
        containerView.addSubview(liveChatVC.view)
        updateConstraints(for: liveChatVC.view)
    }

    private func updateConstraints(for view: UIView) {
        constrain(view, containerView) { view, container in
            view.left == container.left
            view.right == container.right
            view.top == container.top
            view.bottom == container.bottom
        }
    }
}
