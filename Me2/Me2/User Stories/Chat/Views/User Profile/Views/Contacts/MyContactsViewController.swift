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
        navBar.tintColor = .black
        navBar.shouldRemoveShadow(true)
        
        navItem.title = "Мои контакты"
        setUpBackBarButton(for: navItem)
        
        let rightBarButton = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(editContactsList))
        rightBarButton.tintColor = Color.blue
        navItem.rightBarButtonItem = rightBarButton
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
    
    @objc private func editContactsList() {
        viewModel.contactsListEditing = !viewModel.contactsListEditing
        
        if !viewModel.contactsListEditing {
            cancelEditing()
        } else {
            navItem.rightBarButtonItem?.title = "Удалить"
            navItem.rightBarButtonItem?.tintColor = Color.red
            navItem.rightBarButtonItem?.isEnabled = false
            
            let leftBarButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelEditing))
            leftBarButton.tintColor = Color.blue
            navItem.leftBarButtonItem = leftBarButton
            
            tableView.reloadData()
        }
    }
    
    @objc private func cancelEditing() {
        navItem.rightBarButtonItem?.title = "Првить"
        navItem.rightBarButtonItem?.tintColor = Color.blue
        
        navItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        tableView.reloadData()
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
            cell.configure(contact: viewModel.byLetterSections[indexPath.section]?.contacts[indexPath.row].user2 ?? ContactUser(json: JSON()), selectable: viewModel.contactsListEditing)
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.sections[indexPath.section] {
        case .action:
            
            let action = viewModel.actions[indexPath.row]
            action?()
            
        case .byLetterContacts:
            
            if !viewModel.contactsListEditing {
                
                let navigationController = Storyboard.userProfileViewController() as! UINavigationController
                let vc = navigationController.viewControllers[0] as! UserProfileViewController
                vc.viewModel = UserProfileViewModel(userID: viewModel.byLetterSections[indexPath.section]?.contacts[indexPath.row].user2.id ?? 0, profileType: .guestProfile)
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                
                let cell = tableView.cellForRow(at: indexPath) as! ContactTableViewCell
                viewModel.select(cell: cell, atIndexPath: indexPath)
                
            }
            
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
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
    func present(controller: UIViewController, presntationType: PresentationType, completion: VoidBlock?) {
        switch presntationType {
        case .push:
            navigationController?.pushViewController(controller, animated: true)
        case .present:
            present(controller, animated: true, completion: nil)
        }
    }
}
