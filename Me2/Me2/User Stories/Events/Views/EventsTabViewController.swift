//
//  EventsTabViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/23/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

enum EventsListType {
    case ByCategories
    case AllInOne
}

class EventsTabViewController: UIViewController {

    var searchBar = SearchBar.instanceFromNib()
    let searchView = UIView()
    let searchVC = Storyboard.eventsSearchViewController()
    
    let listViewSwitchButton = UIButton()
    let filterButton = UIButton()
    
    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
    
    let viewModel = EventsTabViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        setUpViews()
        configureTableView()
        bindDynamics()
    }
    
    
    private func bindDynamics() {
        viewModel.listType.bind { [weak self] (value) in
            if value == .AllInOne && (self?.viewModel.allEvents.count)! == 0 {
                self?.getAllEvents()
            }
        }
    }
    
    private func getAllEvents() {
        viewModel.getAllEvents { [weak self] (status, message) in
            self?.tableView.reloadSections([0,1], with: .automatic)
        }
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        
        tableView.register(SavedEventsTableViewCell.self)
        tableView.register(NewPlacesListTableViewCell.self)
        tableView.registerNib(EventTableViewCell.self)
        
        for category in viewModel.categories {
            switch category {
            case .actual, .popular, .favourite:
                tableView.register(EventsListTableViewCell.self, forCellReuseIdentifier: category.cellID)
            default:
                break
            }
        }
    }
    
    private func setUpViews() {
        setUpSearchBar()
        setUpSwitchListButton()
        setUpFilterButton()
        setUpTableView()
        setUpSearchView()
    }
    
    private func setUpSearchBar() {
        searchBar.configure(with: self, onSearchEnd: closeSearchView)
        searchBar.backgroundColor = Color.lightGray
        
        self.view.addSubview(searchBar)
        constrain(searchBar, self.view) { search, view in
            search.left == view.left + 20
            search.top == view.top + 40
            search.height == 36
        }
    }
    
    private func setUpSwitchListButton() {
        listViewSwitchButton.setImage(UIImage(named: "listView_icon"), for: .normal)
        listViewSwitchButton.imageView?.contentMode = .scaleAspectFit
        listViewSwitchButton.addTarget(self, action: #selector(switchListType), for: .touchUpInside)
        self.view.addSubview(listViewSwitchButton)
        constrain(listViewSwitchButton, searchBar, self.view) { btn, search, view in
            btn.right == view.right - 20
            btn.centerY == search.centerY
            btn.left == search.right + 20
            btn.height == 25
            btn.width == 25
        }
    }
    
    private func setUpFilterButton() {
        filterButton.setImage(UIImage(named: "filter_icon"), for: .normal)
        filterButton.imageView?.contentMode = .scaleAspectFit
        filterButton.isHidden = true
        filterButton.addTarget(self, action: #selector(showFilter), for: .touchUpInside)
        
        self.view.addSubview(filterButton)
        constrain(filterButton, searchBar, self.view) { btn, search, view in
            btn.right == view.right - 20
            btn.centerY == search.centerY
            btn.left == search.right + 20
            btn.height == 25
            btn.width == 25
        }
    }
    
    private func setUpTableView() {
        self.view.addSubview(tableView)
        constrain(tableView, searchBar, self.view) { table, search, view in
            table.top == search.bottom + 20
            table.left == view.left
            table.right == view.right
            table.bottom == view.bottom
        }
    }
    
    private func setUpSearchView() {
        (searchVC as! EventsSearchViewController).configure(with: EventsSearchViewModel(searchValue: searchBar.searchValue))
        
        searchView.addSubview(searchVC.view)
        constrain(searchVC.view, searchView) { vc, view in
            vc.top == view.top
            vc.left == view.left
            vc.right == view.right
            vc.bottom == view.bottom
        }
        
        searchView.isHidden = true
        
        self.view.addSubview(searchView)
        constrain(searchView, searchBar, self.view) { searchView, searchBar, view in
            searchView.left == view.left
            searchView.top == searchBar.bottom + 10
            searchView.right == view.right
            searchView.bottom == view.bottom
        }
    }
    
    @objc private func switchListType() {
        if viewModel.listType.value == .ByCategories {
            viewModel.listType.value = .AllInOne
            listViewSwitchButton.setImage(UIImage(named: "cardView_icon"), for: .normal)
        } else {
            viewModel.listType.value = .ByCategories
            listViewSwitchButton.setImage(UIImage(named: "listView_icon"), for: .normal)
        }
        
        tableView.reloadData()
    }
    
    @objc private func showFilter() {
        let dest = Storyboard.eventFilterViewController()
        present(dest, animated: true, completion: nil)
    }
    
    @objc private func showFullList() {
        let dest = Storyboard.listOfAllViewController() as! ListOfAllViewController
        dest.viewModel = ListOfAllViewModel(listItemType: .event)
        navigationController?.pushViewController(dest, animated: true)
    }
    
    private func deleteCategory(in section: EventCategoriesType) {
        if let index = viewModel.categories.firstIndex(of: section) {
            viewModel.categories.remove(at: index)
            viewModel.categoryViewModels.remove(at: index)
            
            viewModel.categoriesToShow = viewModel.categories
            
            tableView.deleteSections([index], with: .fade)
        }
    }
}

extension EventsTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section >= viewModel.categories.count { return UIView() }
        
        let header = UIView()
        header.backgroundColor = .white
        
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont(name: "Roboto-Bold", size: 17)
        title.text = viewModel.categories[section].title
        
        header.addSubview(title)
        constrain(title, header) { title, header in
            title.left == header.left + 20
            title.bottom == header.bottom
        }
        
        let moreButton = UIButton()
        moreButton.setTitle("См.все", for: .normal)
        moreButton.setTitleColor(Color.red, for: .normal)
        moreButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 17)
        moreButton.addTarget(self, action: #selector(showFullList), for: .touchUpInside)
        
        header.addSubview(moreButton)
        constrain(moreButton, header) { btn, header in
            btn.right == header.right - 20
            btn.bottom == header.bottom
            btn.height == 20
            btn.width == 60
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.listType.value {
        case .ByCategories:
            switch section {
            case 0:
                return 0
            default:
                return 40
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.categoriesToShow.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.categoriesToShow[section] == .all {
            return viewModel.allEvents.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.categoriesToShow[indexPath.section]
        
        switch section {
        case .saved:
            
            let cell: SavedEventsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            cell.configure(with: 3)
            
            return cell
            
        case .popular, .actual, .favourite:
        
            let cell = tableView.dequeueReusableCell(withIdentifier: section.cellID, for: indexPath) as! EventsListTableViewCell
            cell.selectionStyle = .none
            cell.configure(with: viewModel.categoryViewModels[indexPath.section], presenterDelegate: self) { [weak self] (itemsCount) in
                if itemsCount == 0 {
                    self?.deleteCategory(in: section)
                }
            }
            return cell
                
        case .all:
                
            let cell: EventTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(wtih: viewModel.allEvents[indexPath.row])
            
            return cell
        
        case .new_places:
            
            let cell: NewPlacesListTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(with: viewModel.newPlacesViewModel, presenterDelegate: self)
            return cell
            
        }
    }
}

extension EventsTabViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        listViewSwitchButton.isHidden = true
        filterButton.isHidden = false
        
        searchView.isHidden = false
    }
    
    private func closeSearchView() {
        listViewSwitchButton.isHidden = false
        filterButton.isHidden = true
        
        searchView.isHidden = true
    }
}

extension EventsTabViewController: ControllerPresenterDelegate {
    func present(controller: UIViewController) {
        present(controller, animated: true, completion: nil)
    }
}
