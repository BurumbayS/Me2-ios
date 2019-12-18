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

    @IBOutlet weak var tableView: TableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableViewTopContraint: NSLayoutConstraint!
    
    let interestsHeader = ProfileSectionHeader()
    let favouritePlacesHeader = ProfileSectionHeader()
    
    var viewModel = UserProfileViewModel(profileType: .myProfile)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTableView()
        configureViewModel()
        fetchData()
    }

    private func configureNavBar() {
        self.removeBackButton()
        
        navBar.makeTransparentBar()
        navItem.title = ""
        navBar.tintColor = .black
        navigationController?.navigationBar.tintColor = .black
        
        switch viewModel.profileType {
        case .guestProfile:
            
            setUpBackBarButton(for: navItem)
            navItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "dots_icon"), style: .plain, target: self, action: #selector(moreActions))
            
        default:
            
            navBar.isHidden = true
            
        }
    }
    
    private func configureViewModel() {
        viewModel.presenterDelegate = self
        viewModel.parentVC = self
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableViewTopContraint.constant = UIApplication.shared.statusBarFrame.height
        tableView.isHidden = true
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 30
        
        tableView.registerNib(UserProfileHeaderTableViewCell.self)
        tableView.registerNib(GuestProfileHeaderTableViewCell.self)
        tableView.register(TagsTableViewCell.self)
        tableView.register(FavouritePlacesTableViewCell.self)
        tableView.register(AddInterestsTableViewCell.self)
        tableView.register(MyProfileAdditionalTableViewCell.self)
        tableView.register(GuestProfileAdditionalTableViewCell.self)
    }
    
    private func byndDynamics() {
        viewModel.favouritePlaces.bind { [weak self] (places) in
            self?.tableView.reloadData()
        }
        viewModel.userInfo.bind { [weak self] (user) in
            self?.tableView.reloadData()
        }
    }
    
    func fetchData() {
        viewModel.fetchData { [weak self] (status, message) in
            switch status {
            case .ok:
                
                self?.byndDynamics()
                
                self?.tableView.isHidden = false
                self?.tableView.reloadDataWithCompletion {
                    self?.showHint()
                }
                
            case .error:
                break
            case .fail:
                break
            }
        }
    }
    
    @objc private func moreActions() {
        if let contact = viewModel.userInfo.value.contact, contact.id != 0 {
            if contact.blocked {
                self.addActionSheet(titles:  ["Разблокировать пользователя", "Пожаловаться на пользователя"], actions: [unblockUser, complainToUser], styles: [.default, .destructive])
            } else {
                self.addActionSheet(titles:  ["Заблокировать пользователя", "Пожаловаться на пользователя"], actions: [blockUser, complainToUser], styles: [.destructive, .destructive])
            }
        } else {
            self.addActionSheet(titles:  ["Пожаловаться на пользователя"], actions: [complainToUser], styles: [.destructive])
        }
    }
    
    private func blockUser() {
        viewModel.blockUser()
    }
    
    private func unblockUser() {
        viewModel.unblockUser()
    }
    
    private func complainToUser() {
        let vc = Storyboard.complainViewController() as! ComplainViewController
        vc.viewModel = ComplainViewModel(userID: viewModel.userID)
        present(vc, animated: true, completion: nil)
    }
    
    private func showHint() {
        if UserDefaults().object(forKey: UserDefaultKeys.firstLaunch.rawValue) != nil { return }
        
        if viewModel.profileType == .myProfile {
            let vc = Storyboard.profileHintViewController()
            vc.modalPresentationStyle = .custom
            present(vc, animated: false, completion: nil)
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
                let vc = Storyboard.favouritePlacesViewController() as! FavouritePlacesViewController
                vc.viewModel = FavouritePlacesViewModel(places: self?.viewModel.favouritePlaces ?? Dynamic([]), isEditable: self?.viewModel.profileType == .myProfile)
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
            return 1
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
            return 1
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
            
            switch viewModel.profileType {
            case .myProfile:
                
                let cell: UserProfileHeaderTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.selectionStyle = .none
                cell.configure(user: viewModel.userInfo, viewController: self)
                return cell
                
            case .guestProfile:
                
                let cell: GuestProfileHeaderTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.selectionStyle = .none
                cell.configure(viewModel: viewModel, viewController: self)
                return cell
                
            }
            
        case .interests:
            
            if viewModel.userInfo.value.interests.count > 0 {

                let cell: TagsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.clipsToBounds = true
                cell.selectionStyle = .none
                cell.configure(tagsType: .normal, tagsList: TagsList(items: viewModel.userInfo.value.interests), expanded: viewModel.tagsExpanded)
                return cell

            } else {
            
                let cell: AddInterestsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.clipsToBounds = true
                cell.selectionStyle = .none
                cell.configure(for: viewModel.profileType) { [weak self] in
                    let vc = Storyboard.editProfileViewController() as! EditProfileViewController
                    vc.viewModel = EditProfileViewModel(userInfo: (self?.viewModel.userInfo)!, activateAddTag: true)
                    self?.present(vc, animated: true, completion: nil)
                }
                return cell
                
            }
            
        case .favourite_places:
            
            let cell: FavouritePlacesTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(with: viewModel.favouritePlaces.value, profileType: viewModel.profileType, onPlaceSelected: { [weak self] (place) in
                let vc = Storyboard.placeProfileViewController() as! PlaceProfileViewController
                vc.viewModel = PlaceProfileViewModel(place: place)
                self?.navigationController?.pushViewController(vc, animated: true)
            }) { [weak self] in
                let vc = Storyboard.addFavouritePlaceViewController() as! AddFavouritePlaceViewController
                vc.viewModel = AddFavouritePlaceViewModel(favouritePlaces: (self?.viewModel.favouritePlaces.value)!, onAddPlace: { [weak self] (place) in
                    self?.viewModel.favouritePlaces.value.append(place)
                    self?.tableView.reloadSections([0], with: .automatic)
                })
                self?.navigationController?.pushViewController(vc, animated: true)
            }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedCell(at: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UserProfileViewController: ControllerPresenterDelegate {
    func present(controller: UIViewController, presntationType: PresentationType, completion: VoidBlock?) {
        switch presntationType {
        case .push:
            navigationController?.pushViewController(controller, animated: true)
        case .present:
            present(controller, animated: true, completion: nil)
        }
    }
}
