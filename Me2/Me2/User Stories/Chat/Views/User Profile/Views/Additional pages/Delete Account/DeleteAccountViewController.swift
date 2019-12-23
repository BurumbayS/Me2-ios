//
//  DeleteAccountViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/20/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class DeleteAccountViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    let deleteButton = UIButton()
    
    let viewModel = DeleteAccountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTableView()
    }

    private func configureNavBar() {
        navBar.tintColor = .black
        
        setUpBackBarButton(for: navItem)
        navItem.title = "Удалить аккаунт"
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        tableView.registerNib(DeleteAccountTableViewCell.self)
        tableView.registerNib(ConfirmPasswordTableViewCell.self)
    }
    
    @objc private func deleteAccount() {
        viewModel.deleteAccount { (status, message) in
            switch status {
            case .ok:
                UserDefaults().removeObject(forKey: UserDefaultKeys.token.rawValue)
                window.rootViewController = Storyboard.signInOrUpViewController()
            default:
                break
            }
        }
    }
    
    private func enableDeleteButton() {
        deleteButton.isEnabled = true
        deleteButton.alpha = 1.0
    }
    private func disableDeleteButton() {
        deleteButton.isEnabled = false
        deleteButton.alpha = 0.5
    }
}

extension DeleteAccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        
        let title = UILabel()
        title.textColor = .gray
        title.font = UIFont(name: "Roboto-Regular", size: 15)
        title.text = "Укажите причину удаления аккаунта"
        
        header.addSubview(title)
        constrain(title, header) { title, header in
            title.left == header.left + 20
            title.top == header.top + 20
            title.bottom == header.bottom - 10
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.clipsToBounds = true
        
        deleteButton.setTitleColor(Color.red, for: .normal)
        deleteButton.setTitle("Удалить аккаунт", for: .normal)
        deleteButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 17)
        deleteButton.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
        
        if viewModel.selectedReasonIndex == -1 { disableDeleteButton() }
        
        footer.addSubview(deleteButton)
        constrain(deleteButton, footer) { button, footer in
            button.top == footer.top
            button.left == footer.left
            button.right == footer.right
            button.bottom == footer.bottom
        }
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 50
        default:
            return 0.000001
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.000001
        default:
            return 100
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.reasons.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            
            let cell: DeleteAccountTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(reasonType: viewModel.reasons[indexPath.row], reasonText: viewModel.reasonText, selected: viewModel.selectedReasonIndex == indexPath.row)
            return cell
            
        default:
            
            let cell: ConfirmPasswordTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(password: viewModel.password)
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        enableDeleteButton()
        
        if indexPath.section == 0 {
            viewModel.selectedReasonIndex = indexPath.row
            tableView.reloadData()
        }
    }
    
}
