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
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = ChatTabViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTableView()
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.title = "Чаты"
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.searchBar.placeholder = "Поиск"
        search.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        navigationItem.searchController = search
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new_chat_icon"), style: .plain, target: self, action: nil)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(ChatTableViewCell.self)
    }
    
    private func createNewChat() {
        let contactsVC = Storyboard.contactsViewController()
        present(contactsVC, animated: true, completion: nil)
    }
    
    private func clearChat() {
        
    }
    
    private func deleteChat() {
        
    }
}

extension ChatTabViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
}

extension ChatTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChatTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
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
        let vc = Storyboard.chatViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
