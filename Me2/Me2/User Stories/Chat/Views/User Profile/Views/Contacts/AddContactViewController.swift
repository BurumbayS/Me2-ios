//
//  AddContactViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/18/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class AddContactViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = AddContactViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewModel()
        configureNavBar()
        configureSearchBar()
        configureTableView()
    }
    
    private func configureViewModel() {
        viewModel.configureActions()
        bindDynamics()
    }
    
    private func bindDynamics() {
        viewModel.contactsSynchronized.bind { [weak self] (value) in
            self?.viewModel.actionTypes = [.inviteFriend]
            self?.tableView.reloadSections([0], with: .none)
            
            self?.viewModel.sections.append(.synchronizedContacts)
            let indexSet = IndexSet(arrayLiteral: (self?.viewModel.sections.count)! - 1)
            self?.tableView.insertSections(indexSet, with: .fade)
        }
        
        viewModel.updateSearchResults.bind { [weak self] (_) in
            if (self?.viewModel.sections.contains(.searchResults))! {
                
            }
        }
    }
    
    private func configureNavBar() {
        navBar.tintColor = .black
        navBar.shouldRemoveShadow(true)
        
        navItem.title = "Добавить контакт"
        setUpBackBarButton(for: navItem)
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.returnKeyType = .done
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.sectionFooterHeight = 0
        
        tableView.registerNib(ContactTableViewCell.self)
        tableView.registerNib(ContactsActionTableViewCell.self)
    }
    
    private func updateSearchResults() {
        if viewModel.sections.contains(.searchResults) {
            tableView.reloadSections([1], with: .top)
            return
        }
        
        if viewModel.sections.count > 1 {
            viewModel.sections.replaceSubrange(1...viewModel.sections.count-1, with: [.searchResults, .synchronizedContacts])
        } else {
            viewModel.sections.append(.searchResults)
        }
        
        tableView.insertSections([1], with: .top)
    }
    
    private func addNewContact(contact: User) {
        viewModel.myContacts.append(contact)
        tableView.reloadData()
        
        viewModel.addToContactsUser(withID: contact.id) { [weak self] (status, message) in
            switch status {
            case .ok:
                break
            case .error:
                
                self?.viewModel.myContacts.removeAll(where: { $0.id == contact.id })
                self?.tableView.reloadData()
                
            case .fail:
                
                self?.viewModel.myContacts.removeAll(where: { $0.id == contact.id })
                self?.tableView.reloadData()
                
            }
        }
    }
}

extension AddContactViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel.sections[section] {
        case .searchResults, .synchronizedContacts:
            let headerView = UIView()
            
            headerView.backgroundColor = .white
            
            let line = UIView()
            line.backgroundColor = Color.gray
            headerView.addSubview(line)
            constrain(line, headerView) { line, view in
                line.top == view.top
                line.left == view.left
                line.right == view.right
                line.height == 1
            }
            
            let titleLabel = UILabel()
            titleLabel.text = viewModel.sections[section].title
            titleLabel.font = UIFont(name: "Roboto-Medium", size: 15)
            titleLabel.textColor = .darkGray
            
            headerView.addSubview(titleLabel)
            constrain(titleLabel, headerView) { title, view in
                title.left == view.left + 20
                title.bottom == view.bottom - 5
                title.height == 20
            }
            
            return headerView
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.sections[section] {
        case .action:
            return CGFloat(Float.leastNonzeroMagnitude)
        case .searchResults, .synchronizedContacts:
            return 40
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.sections[section] {
        case .action:
            return viewModel.actionTypes.count
        case .synchronizedContacts:
            return viewModel.synchronizedUsers.count
        case .searchResults:
            return viewModel.searchResults.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.sections[indexPath.section] {
        case .action:
            
            let cell: ContactsActionTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(actionType: viewModel.actionTypes[indexPath.row])
            return cell
            
        default:
            
            let cell: ContactTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            
            let contact = viewModel.contactForCell(at: indexPath)
            let added = viewModel.myContacts.contains(where: { $0.id == contact.id })
            cell.configure(contact: contact, addable: true, added: added) { [weak self] in
                self?.addNewContact(contact: contact)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.sections[indexPath.section] {
        case .action:
            let action = viewModel.actions[indexPath.row]
            action?()
        default:
            break
        }
    }
}

extension AddContactViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        viewModel.searchValue.value = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        
        if let username = searchBar.text, username != "" {
            viewModel.searchUser(by: username) { [weak self] (status, message) in
                switch status {
                case .ok:
                    
                    self?.updateSearchResults()
                    
                case .error:
                    break
                case .fail:
                    break
                }
            }
        }
    }
}
