//
//  UserProfileViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/9/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class UserProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    
    let viewModel = UserProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTableView()
    }
    
    private func configureNavBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        navBar.isTranslucent = false
        navBar.shouldRemoveShadow(true)
        navBar.tintColor = .black
        navItem.title = ""
        navItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "dots_icon"), style: .plain, target: self, action: nil)
        setUpBackBarButton(for: navItem)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 30
        
        tableView.registerNib(UserProfileHeaderTableViewCell.self)
        tableView.register(TextTableViewCell.self)
        tableView.register(FavouritePlacesTableViewCell.self)
    }
}

extension UserProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont(name: "Roboto-Regular", size: 17)
        label.text = viewModel.sections[section].rawValue
        
        headerView.addSubview(label)
        constrain(label, headerView) { label, header in
            label.left == header.left
            label.top == header.top + 10
            label.bottom == header.bottom
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.sections[section] {
        case .bio, .username, .favourite_places:
            return 30
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        
        switch viewModel.sections[section] {
        case .header:
            footer.backgroundColor = .white
        default:
            footer.backgroundColor = Color.lightGray
        }
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.sections[indexPath.section] {
        case .favourite_places:
            let vc = Storyboard.favouritePlacesViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    private func cell(for indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.sections[indexPath.section]
        
        let cell: TextTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        
        switch section {
        case .header:
            let cell: UserProfileHeaderTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            return cell
        case .username:
            cell.configure(with: Color.blue, text: "maria_zzz")
        case .bio:
            cell.configure(with: .black, text: "Люблю экстремальный спорт и прогулки по вечернему городу.")
        case .favourite_places:
            let cell: FavouritePlacesTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            cell.configure(with: 10)
            return cell
        case .block:
            cell.configure(with: Color.red, text: "Заблокировать")
        case .complain:
            cell.configure(with: Color.red, text: "Пожаловаться на пользователя")
        }
        
        return cell
    }
}
