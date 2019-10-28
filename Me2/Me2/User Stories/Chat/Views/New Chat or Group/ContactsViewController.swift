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

    let tableView = UITableView()
    let searchBar = SearchBar.instanceFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        setUpViews()
        setUpTableView()
    }

    private func setUpNavBar() {
        navigationController?.navigationBar.tintColor = Color.red
        navigationController?.navigationBar.shouldRemoveShadow(true)

        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont(name: "SFProRounded-Regular", size: 20)
        label.text = "Контакты"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add_contact_icon"), style: .plain, target: self, action: #selector(addNewContact))
    }
    
    @objc private func addNewContact() {
        
    }
    
    private func setUpViews() {
        searchBar.backgroundColor = Color.lightGray
        
        self.view.addSubview(searchBar)
        constrain(searchBar, self.view) { bar, view in
            bar.left == view.left + 10
            bar.right == view.right - 10
            bar.top == view.top + 10
            bar.height == 36
        }
        
        self.view.addSubview(tableView)
        constrain(tableView, searchBar, self.view) { table, bar, view in
            table.left == view.left
            table.right == view.right
            table.top == bar.bottom + 10
            table.bottom == view.bottom
        }
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        
        tableView.registerNib(ContactTableViewCell.self)
        tableView.register(CreateGroupTableViewCell.self)
    }
}

extension ContactsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
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
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 15
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: CreateGroupTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            return cell
        default:
            let cell : ContactTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(selectable: false)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let vc = Storyboard.createGroupViewController()
            present(vc, animated: true, completion: nil)
        default:
            break;
        }
    }
}
