//
//  EditProfileViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/3/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        configureTableView()
    }
    
    private func configureNavBar() {
        navbar.isTranslucent = false
        navbar.shouldRemoveShadow(true)
        
        navItem.title = "Редактировать профиль"
        
        let cancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelEditing))
        cancelButton.tintColor = Color.red
        navItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(finishEditing))
        doneButton.tintColor = Color.blue
        navItem.rightBarButtonItem = doneButton
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = Color.lightGray
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        
        tableView.registerNib(EditProfileHeaderTableViewCell.self)
    }
    
    @objc private func cancelEditing() {
        
    }
    
    @objc private func finishEditing() {
        
    }
}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EditProfileHeaderTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
}
