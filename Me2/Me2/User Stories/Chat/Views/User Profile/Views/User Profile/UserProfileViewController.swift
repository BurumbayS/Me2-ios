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
    
    let interestsHeader = ProfileSectionHeader()
    let favouritePlacesHeader = ProfileSectionHeader()
    
    let viewModel = UserProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTableView()
        fetchData()
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.isHidden = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        navBar.isTranslucent = false
        navBar.shouldRemoveShadow(true)
        navBar.tintColor = .black
        
        navItem.title = ""
        
        if (viewModel.profileType == .guestProfile) { setUpBackBarButton(for: navItem) }
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.isHidden = true
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 30
        
        tableView.registerNib(UserProfileHeaderTableViewCell.self)
        tableView.register(TagsTableViewCell.self)
        tableView.register(FavouritePlacesTableViewCell.self)
        tableView.register(AddInterestsTableViewCell.self)
        tableView.register(MyProfileAdditionalTableViewCell.self)
        tableView.register(GuestProfileAdditionalTableViewCell.self)
    }
    
    func fetchData() {
        viewModel.fetchData { [weak self] (status, message) in
            switch status {
            case .ok:
                
                self?.tableView.isHidden = false
                self?.tableView.reloadData()
                
            case .error:
                break
            case .fail:
                break
            }
        }
    }
}

extension UserProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel.sections[section] {
        case .interests:
            
            interestsHeader.configure(title: viewModel.sections[section].rawValue, type: .expand) { [weak self] in
                self?.viewModel.tagsExpanded.value = !(self?.viewModel.tagsExpanded.value)!
                self?.tableView.reloadSections([section], with: .automatic)
            }
            return interestsHeader
            
        case .favourite_places:
            
            favouritePlacesHeader.configure(title: viewModel.sections[section].rawValue, type: .seeMore) { [weak self] in
                let vc = Storyboard.favouritePlacesViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return favouritePlacesHeader
            
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
    
    private func cell(for indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.sections[indexPath.section]
        
        switch section {
        case .bio:
            
            let cell: UserProfileHeaderTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(user: viewModel.userInfo, profileType: viewModel.profileType, viewController: self)
            return cell
            
        case .interests:
            
            let tags = [String]()
            if tags.count > 0 {
                
                let cell: TagsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.clipsToBounds = true
                cell.configure(tagsType: .normal, tagsList: TagsList(), expanded: viewModel.tagsExpanded)
                return cell
                
            } else {
                
                let cell: AddInterestsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.clipsToBounds = true
                cell.configure(for: viewModel.profileType) { [weak self] in
                    let vc = Storyboard.editProfileViewController() as! EditProfileViewController
                    vc.viewModel = EditProfileViewModel(activateAddTag: true)
                    self?.present(vc, animated: true, completion: nil)
                }
                return cell
                
            }
            
        case .favourite_places:
            
            let cell: FavouritePlacesTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(with: 0, profileType: viewModel.profileType)
            return cell
            
        case .additional_block:
            
            switch viewModel.profileType {
            case .myProfile:
                
                let cell: MyProfileAdditionalTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configure(with: viewModel.myProfileCells[indexPath.row])
                return cell
                
            case .guestProfile:
                
                let cell: GuestProfileAdditionalTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configure(with: viewModel.guestProfileCells[indexPath.row])
                return cell
                
            }

        }

    }
}

extension UserProfileViewController: ControllerPresenterDelegate {
    func present(controller: UIViewController, presntationType: PresentationType) {
        switch presntationType {
        case .push:
            navigationController?.pushViewController(controller, animated: true)
        case .present:
            present(controller, animated: true, completion: nil)
        }
    }
}
