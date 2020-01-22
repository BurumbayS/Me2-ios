//
//  ContactsViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/5/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class ContactsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var emptyContactListStatus: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: ContactsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        setUpTableView()
        
        configureSearchBar()
        bindDynamics()
        
        fetchData()
    }
    
    private func fetchData() {
        viewModel.getContacts { [weak self] (status, message) in
            self?.emptyContactListStatus.isHidden = ((self?.viewModel.byLetterSections.count)! > 0) ? true : false
            self?.tableView.reloadData()
        }
    }
    
    private func setUpNavBar() {
        navBar.tintColor = Color.red
        navBar.isTranslucent = false
        navBar.shouldRemoveShadow(true)

        navItem.title = "Новый чат"
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelNewChat))
    }
    
    @objc private func cancelNewChat() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        
        tableView.registerNib(ContactTableViewCell.self)
        tableView.register(CreateGroupTableViewCell.self)
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.returnKeyType = .done
    }
    
    private func bindDynamics() {
        viewModel.updateSearchResults.bind { [weak self] (update) in
            self?.tableView.reloadData()
        }
    }
}

extension ContactsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            viewModel.searchActivated = false
            emptyContactListStatus.isHidden = false
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        emptyContactListStatus.isHidden = true
        viewModel.searchActivated = true
    }
}

extension ContactsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        headerView.backgroundColor = Color.lightGray

        let letterLabel = UILabel()
        letterLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        letterLabel.textColor = .gray

        headerView.addSubview(letterLabel)
        constrain(letterLabel, headerView) { letter, view in
            letter.left == view.left + 26
            letter.top == view.top
            letter.bottom == view.bottom
        }
        
        if viewModel.searchActivated {
            letterLabel.text = "Результаты поиска"
        } else {
            letterLabel.text = viewModel.byLetterSections[section].letter
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.searchActivated {
            return 1
        } else {
            return viewModel.byLetterSections.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.searchActivated {
            return viewModel.searchResults.count
        } else {
            return viewModel.byLetterSections[section].contacts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell : ContactTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let contact = (viewModel.searchActivated) ? viewModel.searchResults[indexPath.row] : viewModel.byLetterSections[indexPath.section].contacts[indexPath.row]
        cell.configure(contact: contact.user2, selectable: false)
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        
        if viewModel.searchActivated {
            viewModel.contactSelectionHandler?(viewModel.searchResults[indexPath.row].user2.id)
        } else {
            let contact = viewModel.byLetterSections[indexPath.section].contacts[indexPath.row]
            viewModel.contactSelectionHandler?(contact.user2.id)
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension ContactsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            viewModel.searchActivated = false
            tableView.reloadData()
        } else {
            viewModel.searchActivated = true
            viewModel.searchContact(by: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchActivated = false
        self.view.endEditing(true)
        
        self.tableView.reloadData()
    }
}
