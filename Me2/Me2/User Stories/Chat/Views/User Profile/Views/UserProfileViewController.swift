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
        setUpBackBarButton(for: navItem)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 30
        
        tableView.registerNib(UserProfileHeaderTableViewCell.self)
        tableView.register(TextTableViewCell.self)
        tableView.register(TagsTableViewCell.self)
        tableView.register(FavouritePlacesTableViewCell.self)
        tableView.register(AddInterestsTableViewCell.self)
        tableView.register(MyProfileAdditionalTableViewCell.self)
        tableView.register(GuestProfileAdditionalTableViewCell.self)
    }
}

extension UserProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel.sections[section] {
        case .interests:
            
            let header = ProfileSectionHeader()
            header.configure(title: viewModel.sections[section].rawValue, type: .expand)
            return header
            
        case .favourite_places:
            
            let header = ProfileSectionHeader()
            header.configure(title: viewModel.sections[section].rawValue, type: .seeMore)
            return header
            
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.sections[section] {
        case .interests, .favourite_places:
            return 50
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch viewModel.sections[section] {
        case .favourite_places:
            return 30
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.sections[section] {
        case .additional_block:
            return viewModel.getNumberOfCellsForAdditionalBlock()
        default:
            return 1
        }
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
        
        switch section {
        case .bio:
            
            let cell: UserProfileHeaderTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            return cell
            
        case .interests:
            
            let tags = [String]()
            if tags.count > 0 {
                let cell: TagsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configure(tagsType: .normal, tagsList: TagsList())
                return cell
            } else {
                let cell: AddInterestsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                return cell
            }
            
        case .favourite_places:
            
            let cell: FavouritePlacesTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(with: 10)
            return cell
            
        case .additional_block:
            
            switch viewModel.profileType {
            case .myProfile:
                
                let cell: MyProfileAdditionalTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                return cell
                
            case .guestProfile:
                
                let cell: GuestProfileAdditionalTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configure(title: viewModel.guestProfileCells[indexPath.row].rawValue, textColor: .red)
                return cell
                
            }

        }
    
    }
}
