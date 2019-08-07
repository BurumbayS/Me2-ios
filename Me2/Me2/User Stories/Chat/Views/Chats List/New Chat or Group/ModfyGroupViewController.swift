//
//  ModfyGroupViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/7/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class ModfyGroupViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureNavBar()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 30
        
        tableView.registerNib(ContactTableViewCell.self)
        tableView.register(EditGroupInfoTableViewCell.self)
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Новая группа"
        
        let rightItem = UIBarButtonItem(title: "Создать", style: .plain, target: self, action: nil)
        rightItem.tintColor = Color.blue
        navigationItem.rightBarButtonItem = rightItem
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}

extension ModfyGroupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = Color.lightGray
        
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 13)
        label.textColor = .gray
        label.text = "Участники"
        
        headerView.addSubview(label)
        constrain(label, headerView) { label, header in
            label.top == header.top + 5
            label.bottom == header.bottom - 5
            label.left == header.left + 10
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 25
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: EditGroupInfoTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: self) { [weak self] (title) in
                if title == "" {
                    self?.navigationItem.rightBarButtonItem?.isEnabled = false
                } else {
                    self?.navigationItem.rightBarButtonItem?.isEnabled = true
                }
            }
            return cell
        default:
            let cell: ContactTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(selectable: false)
            return cell
        }
    }
}

protocol PresenterDelegate {
    func present(controller: UIViewController)
    func presentAlert(with titles: [String], actions: [VoidBlock?], styles: [UIAlertAction.Style])
}
extension ModfyGroupViewController : PresenterDelegate {
    func presentAlert(with titles: [String], actions: [VoidBlock?], styles: [UIAlertAction.Style]) {
        self.addActionSheet(with: titles, and: actions, and: styles)
    }
    
    func present(controller: UIViewController) {
        present(controller, animated: true, completion: nil)
    }
}

extension ModfyGroupViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text, text.count > 0 {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}
