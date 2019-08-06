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
        searchBar.backgroundColor = .lightGray
        
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
}
