 //
//  MyContactsViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/17/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import SwiftyJSON
import Cartography

class MyContactsViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: MyContactsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewModel()
        configureTableView()
        configureSearchBar()
        configureNavBar()
        fetchData()
        bindDynamics()
    }
    
    private func fetchData() {
        viewModel.fetchMyContacts()
    }
    
    private func configureViewModel() {
        viewModel = MyContactsViewModel(presenterDelegate: self)
        viewModel.configureActions()
    }
    
    private func bindDynamics() {
        viewModel.updateContactsList.bind { [weak self] (_) in
            self?.tableView.reloadData()
        }
    }
    
    private func configureNavBar() {
        navBar.shouldRemoveShadow(true)
        
        navItem.title = "Мои контакты"
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
    
}
 
 extension MyContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel.sections[section] {
        case .byLetterContacts:
            let headerView = UIView()
            
            headerView.backgroundColor = Color.lightGray
            
            let letterLabel = UILabel()
            letterLabel.text = (viewModel.byLetterSections[section]?.letter)?.uppercased()
            letterLabel.font = UIFont(name: "Roboto-Regular", size: 13)
            letterLabel.textColor = .gray
            
            headerView.addSubview(letterLabel)
            constrain(letterLabel, headerView) { letter, view in
                letter.left == view.left + 26
                letter.top == view.top
                letter.bottom == view.bottom
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
        case .byLetterContacts:
            return 15
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
            return viewModel.actions.count
        case .byLetterContacts:
            return viewModel.byLetterSections[section]?.contacts.count ?? 0
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
            cell.configure(contact: viewModel.byLetterSections[indexPath.section]?.contacts[indexPath.row] ?? User(json: JSON()))
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
 
extension MyContactsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        viewModel.searchValue.value = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
 
 extension MyContactsViewController: ControllerPresenterDelegate {
    func present(controller: UIViewController, presntationType: PresentationType) {
        switch presntationType {
        case .push:
            navigationController?.pushViewController(controller, animated: true)
        case .present:
            present(controller, animated: true, completion: nil)
        }
    }
 }
