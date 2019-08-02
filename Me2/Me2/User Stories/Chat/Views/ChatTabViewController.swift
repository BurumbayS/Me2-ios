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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        containerView.self = chatsListVC.view
        containerView.addSubview(chatsListVC.view)
        updateConstraints(for: chatsListVC.view)
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
