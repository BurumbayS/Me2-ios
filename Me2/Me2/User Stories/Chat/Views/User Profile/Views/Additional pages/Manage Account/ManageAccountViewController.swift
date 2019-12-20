//
//  ManageAccountViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/4/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography
import IQKeyboardManagerSwift

class ManageAccountViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = ManageAccountViewModel()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.updateData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureNavBar()
    }
    
    private func configureNavBar() {
        navBar.tintColor = .black
        setUpBackBarButton(for: navItem)
        
        navItem.title = "Управление аккаунтом"
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        
        tableView.register(ManageAccountTableViewCell.self)
    }

}

extension ManageAccountViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        
        let title = UILabel()
        title.textColor = .darkGray
        title.text = viewModel.sections[section].title
        title.font = UIFont(name: "Roboto-Regular", size: 13)
        header.addSubview(title)
        constrain(title, header) { title, header in
            title.bottom == header.bottom - 5
            title.left == header.left + 20
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.sections[section] {
        case .delete:
            return 20
        default:
            return 40
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellsCount(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ManageAccountTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
        cell.configure(with: viewModel.modelForCell(at: indexPath))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.sections[indexPath.section] {
        case .security:
            
            switch viewModel.securityTypes[indexPath.row] {
            case .changePassword:
                
                let vc = Storyboard.changePasswordViewController()
                navigationController?.pushViewController(vc, animated: true)
                
            case .changePhoneNumber:
                
                let vc = Storyboard.changePhoneNumberViewController()
                navigationController?.pushViewController(vc, animated: true)
                
            case .accessCode:
                
                if let _ = UserDefaults().object(forKey: UserDefaultKeys.accessCode.rawValue) as? String {
                    
                    let vc = Storyboard.accessCodeViewController() as! AccessCodeViewController
                    
                    vc.viewModel = AccessCodeViewModel(type: .check, onCorrectAccessCode: {
                        let vc = Storyboard.configureAccessCodeViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    })
                    
                    present(vc, animated: true, completion: nil)
                    
                } else {
                    
                    let vc = Storyboard.configureAccessCodeViewController()
                    navigationController?.pushViewController(vc, animated: true)
                    
                }
                
            }
            
        case .privacy:
            
            let cell = tableView.cellForRow(at: indexPath) as? ManageAccountTableViewCell
            cell?.pickerTextField.becomeFirstResponder()
            
        case .delete:
            
            let vc = Storyboard.deleteAccountViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
    }
}
