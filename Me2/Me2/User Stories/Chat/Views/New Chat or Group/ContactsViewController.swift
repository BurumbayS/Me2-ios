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
    
    let searchBar = SearchBar.instanceFromNib()
    
    var viewModel: ContactsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        setUpTableView()
        
        configureSearchBar()
        bindDynamics()
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
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        
        tableView.registerNib(ContactTableViewCell.self)
        tableView.register(CreateGroupTableViewCell.self)
    }
    
    private func configureSearchBar() {
        searchBar.configure(with: self) {
            
        }
        
        viewModel.searchValue = searchBar.searchValue
    }
    
    private func bindDynamics() {
        viewModel.bindDynamics()
        
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
        
        switch section {
        case 0:
            
            searchBar.backgroundColor = Color.lightGray
    
            headerView.addSubview(searchBar)
            constrain(searchBar, headerView) { bar, view in
                bar.left == view.left + 10
                bar.right == view.right - 10
                bar.centerY == view.centerY
                bar.height == 36
            }
            
        default:
            
            headerView.backgroundColor = Color.lightGray

            let letterLabel = UILabel()
            letterLabel.text = "A"
            letterLabel.font = UIFont(name: "Roboto-Regular", size: 13)
            letterLabel.textColor = .gray

            headerView.addSubview(letterLabel)
            constrain(letterLabel, headerView) { letter, view in
                letter.left == view.left + 26
                letter.top == view.top
                letter.bottom == view.bottom
            }
            
        }
        
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 66
        default:
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        default:
            return viewModel.searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            
            return UITableViewCell()
            
        default:
            
            let cell : ContactTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(contact: viewModel.searchResults[indexPath.row], selectable: false)
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            
            self.view.endEditing(true)
            
            viewModel.contactSelectionHandler?(viewModel.searchResults[indexPath.row].id)
            
            dismiss(animated: true, completion: nil)
            
        default:
            break;
        }
    }
}
