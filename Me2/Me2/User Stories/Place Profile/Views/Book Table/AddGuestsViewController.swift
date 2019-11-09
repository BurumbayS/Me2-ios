//
//  AddGuestsViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/1/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class AddGuestsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var viewModel: AddGuestViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        
        tableView.registerNib(ContactTableViewCell.self)
    }

    private func configureNavBar() {
        navBar.shouldRemoveShadow(true)
        
        navItem.title = "Добавить гостей"
        
        let cancelButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelInviting))
        cancelButton.tintColor = Color.red
        navItem.leftBarButtonItem = cancelButton
        
        let confirmButton = UIBarButtonItem(title: "Отправить", style: .plain, target: self, action: #selector(confirmInviting))
        confirmButton.tintColor = Color.blue
        navItem.rightBarButtonItem = confirmButton
    }
    
    @objc private func cancelInviting() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func confirmInviting() {
        dismiss(animated: true) {
            self.viewModel.completeWithSelection()
        }
    }
}

extension AddGuestsViewController: UITableViewDataSource, UITableViewDelegate {
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
        return 15
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ContactTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
        cell.selectionStyle = .none
//        cell.configure(selectable: true)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ContactTableViewCell
        viewModel.select(cell: cell)
    }
}
