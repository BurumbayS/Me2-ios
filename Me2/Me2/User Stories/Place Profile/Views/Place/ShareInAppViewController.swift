//
//  ShareInAppViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/27/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class ShareInAppViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var viewModel: ShareInAppViewModel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
     
        configureNavBar()
        configureTableView()
        loadContacts()
    }
    
    private func loadContacts() {
        viewModel.getContacts { [weak self] (status, message) in
            self?.tableView.reloadData()
        }
    }
    
    private func configureNavBar() {
        navBar.tintColor = .black
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Отправить", style: .plain, target: self, action: #selector(shareWithContacts))
        navItem.rightBarButtonItem?.tintColor = Color.blue
        navItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(goBack))
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(ContactTableViewCell.self)
    }
    
    @objc private func shareWithContacts() {
        viewModel.shareWithContacts()
    }
    
    @objc private func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ShareInAppViewController: UITableViewDelegate, UITableViewDataSource {
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
        
        letterLabel.text = viewModel.byLetterSections[section].letter
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.byLetterSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.byLetterSections[section].contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : ContactTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let contact = viewModel.byLetterSections[indexPath.section].contacts[indexPath.row]
        cell.configure(contact: contact.user2, selectable: true)
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ContactTableViewCell
        viewModel.select(cell: cell, atIndexPath: indexPath)
    }
}
