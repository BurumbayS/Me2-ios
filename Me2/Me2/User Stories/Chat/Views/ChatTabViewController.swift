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
    @IBOutlet weak var chatsButtonUnderline: UIView!
    @IBOutlet weak var liveButtonUnderline: UIView!
    @IBOutlet weak var additionalActionButton: UIButton!
    
    let viewModel = ChatTabViewModel()
    
    let chatsListVC = Storyboard.chatsListViewController() as! ChatsListViewController
    let liveChatVC = Storyboard.liveChatViewController() as! LiveChatViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        bindViewModel()
        setUpDelegates()
    }
    
    private func bindViewModel() {
        viewModel.currentScreen.bindAndFire { [weak self] (screen) in
            switch screen {
            case .chatList:
                self?.setUpContainerView()
                self?.setUpButtons()
            default:
                self?.setUpContainerView()
                self?.setUpButtons()
            }
        }
    }
    
    private func setUpDelegates() {
        chatsListVC.controllerPresenter = self
        liveChatVC.controllerPresenter = self
    }
    
    private func setUpButtons() {
        switch viewModel.currentScreen.value {
        case .chatList:
            additionalActionButton.setImage(UIImage(named: "new_chat_icon"), for: .normal)
            chatsButton.makeVisible()
            liveButton.makeTransparent()
            chatsButtonUnderline.isHidden = false
            liveButtonUnderline.isHidden = true
        default:
            additionalActionButton.setImage(UIImage(named: "dots_icon"), for: .normal)
            liveButton.makeVisible()
            chatsButton.makeTransparent()
            chatsButtonUnderline.isHidden = true
            liveButtonUnderline.isHidden = false
        }
    }
    
    private func setUpContainerView() {
        containerView.subviews.forEach({ $0.removeFromSuperview() })
        
        switch viewModel.currentScreen.value {
        case .chatList:
            containerView.addSubview(chatsListVC.view)
            updateConstraints(for: chatsListVC.view)
        default:
            containerView.addSubview(liveChatVC.view)
            updateConstraints(for: liveChatVC.view)
        }
    }

    private func updateConstraints(for view: UIView) {
        constrain(view, containerView) { view, container in
            view.left == container.left
            view.right == container.right
            view.top == container.top
            view.bottom == container.bottom
        }
    }
    
    private func createNewChat() {
        let contactsVC = Storyboard.contactsViewController()
        present(contactsVC, animated: true, completion: nil)
    }
    
    @IBAction func chatsButtonPressed(_ sender: Any) {
        viewModel.currentScreen.value = .chatList
    }
    
    @IBAction func liveButtonPressed(_ sender: Any) {
        viewModel.currentScreen.value = .liveChat
    }
    
    @IBAction func additionalButtonPressed(_ sender: Any) {
        switch viewModel.currentScreen.value {
        case .chatList:
            createNewChat()
        default:
            break;
        }
    }
}

extension ChatTabViewController: ControllerPresenterDelegate {
    func present(controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
}
