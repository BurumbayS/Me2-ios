//
//  BlockedContactsViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/28/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class BlockedContactsViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: BlockedContactsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureSearchBar()
        configureTableView()
        bindDynamics()
    }

    private func configureNavBar() {
        navBar.tintColor = .black
        navBar.shouldRemoveShadow(true)
        
        navItem.title = "Заблокированные"
        setUpBackBarButton(for: navItem)
    }
    
    private func configureSearchBar() {
        searchBar.placeholder = "Поиск"
        searchBar.delegate = self
        searchBar.returnKeyType = .done
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.sectionFooterHeight = 0
        
        tableView.registerNib(ContactTableViewCell.self)
    }
    
    private func bindDynamics() {
        viewModel.searchResults.bind { [weak self] (_) in
            self?.tableView.reloadSections([0], with: .automatic)
        }
    }
}

extension BlockedContactsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchUser(withPrefix: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        viewModel.searchActivated = false
        
        searchBar.text = ""
        tableView.reloadSections([0], with: .automatic)
    }
}

extension BlockedContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel.searchActivated) ? viewModel.searchResults.value.count : viewModel.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ContactTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let contact = (viewModel.searchActivated) ? viewModel.searchResults.value[indexPath.row] : viewModel.contacts[indexPath.row]
        cell.configure(contact: contact)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Разблокировать"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            viewModel.unblockContact(atIndex: indexPath.row) { (status, message) in
                
            }
            viewModel.unblockHandler?(viewModel.contacts[indexPath.row])
            
            viewModel.contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
        
    }
}
