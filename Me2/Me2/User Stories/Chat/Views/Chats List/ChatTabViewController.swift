//
//  ChatTabViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/3/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class ChatTabViewController: ListContainedViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let newChatButton = CustomLargeTitleBarButton()
    
    let viewModel = ChatTabViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        loadChatsList()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showNewChatButton(true)
        
        navigationController?.navigationBar.isTranslucent = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        showNewChatButton(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTableView()
        bindDynamics()
    }
    
    private func bindDynamics() {
        viewModel.roomUUIDToOpenFirst.bind { [weak self] (uuid) in
            if uuid != "" {
                self?.viewModel.getRoomInfo(with: uuid) { [weak self] (status, message) in
                    switch status {
                    case .ok:
                        self?.viewModel.roomUUIDToOpenFirst.value = ""
                        self?.goToChat(room: (self?.viewModel.newChatRoom)!)
                    case .error:
                        break
                    case .fail:
                        break
                    }
                }
            }
        }
    }
    
    private func loadChatsList() {
        viewModel.getChatList { [weak self] (status, message) in
            switch status {
            case .ok:
                
                if self?.viewModel.chatsList.count ?? 0 > 0 {
                    self?.hideEmptyListStatusLabel()
                    self?.tableView.reloadSections([0], with: .automatic)
                } else {
                    self?.showEmptyListStatusLabel(withText: "У вас пока нет активных чатов")
                }
                
            case .error:
                break
            case .fail:
                break
            }
        }
    }
    
    private func configureNavBar() {
        extendedLayoutIncludesOpaqueBars = true
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always

        navigationItem.title = "Чаты"
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.searchBar.placeholder = "Поиск"
        search.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        navigationItem.searchController = search
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        newChatButton.add(to: navigationController!.navigationBar, with: UIImage(named: "new_chat_icon")!) { [weak self] in
            self?.createNewChat()
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        
        tableView.registerNib(ChatTableViewCell.self)
    }
    
    private func createNewChat() {
        let contactsVC = Storyboard.contactsViewController() as! ContactsViewController
        contactsVC.viewModel = ContactsViewModel(onContactSelected: { [weak self] (userID) in
            self?.openNewChat(withUser: userID)
        })
        present(contactsVC, animated: true, completion: nil)
    }
    
    private func showNewChatButton(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.newChatButton.alpha = show ? 1.0 : 0.0
        }
    }
        
    private func clearChat() {
        
    }
    
    private func deleteChat() {
        
    }
    
    private func openNewChat(withUser id: Int) {
        viewModel.openNewChat(withUser: id) { [weak self] (status, message) in
            switch status {
            case .ok:
                
                self?.loadChatsList()
                if let room = self?.viewModel.newChatRoom {
                    self?.goToChat(room: room)
                }
                
            case .error:
                break
            case .fail:
                break
            }
        }
    }
    
    private func goToChat(room: Room) {
        switch room.type {
        case .SIMPLE:
            
            let vc = Storyboard.chatViewController() as! ChatViewController
            vc.viewModel = ChatViewModel(room: room)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .LIVE:
            
            let vc = Storyboard.liveChatViewController() as! LiveChatViewController
            vc.viewModel = LiveChatViewModel(room: room)
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
    }
    
//    func openChatOnPush(with uuid: String) {
//        viewModel.getRoomInfo(with: uuid) { [weak self] (status, message) in
//            switch status {
//            case .ok:
//                self?.viewModel.roomUUIDToOpenFirst = ""
//                self?.goToChat(room: (self?.viewModel.newChatRoom)!)
//            case .error:
//                break
//            case .fail:
//                break
//            }
//        }
//    }
}

extension ChatTabViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
}

extension ChatTabViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001//CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001//CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chatsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChatTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(with: viewModel.chatsList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.addActionSheet(with: ["Очистить чат", "Удалить чат"], and: [clearChat, deleteChat], and: [.default, .destructive])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = viewModel.chatsList[indexPath.row]
        
        goToChat(room: room) 
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        newChatButton.moveAndResizeImage(for: height)
    }
}
