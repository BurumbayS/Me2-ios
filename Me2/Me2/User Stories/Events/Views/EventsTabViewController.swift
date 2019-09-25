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
    var listType = EventsListType.ByCategories
    
    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        setUpViews()
        configureTableView()
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
        tableView.register(EventsListTableViewCell.self)
        tableView.register(NewPlacesListTableViewCell.self)
        tableView.registerNib(EventTableViewCell.self)
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
        if listType == .ByCategories {
            listType = .AllInOne
            listViewSwitchButton.setImage(UIImage(named: "cardView_icon"), for: .normal)
        } else {
            listType = .ByCategories
            listViewSwitchButton.setImage(UIImage(named: "listView_icon"), for: .normal)
        }
        
        tableView.reloadData()
    }
    
    @objc private func showFilter() {
        
    }
    
    @objc private func showFullList() {
        let dest = Storyboard.listOfAllViewController() as! ListOfAllViewController
        dest.viewModel = ListOfAllViewModel(listItemType: .place)
        navigationController?.pushViewController(dest, animated: true)
    }
}

extension EventsTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .white
        
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont(name: "Roboto-Bold", size: 17)
        title.text = "Популярное сегодня"
        
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
        switch listType {
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
        switch listType {
        case .ByCategories:
            return 3
        default:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            let cell: SavedEventsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            cell.configure(with: 3)
            
            return cell
            
        case 1:
            
            switch listType {
            case .ByCategories:
                
                let cell: EventsListTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.selectionStyle = .none
                return cell
                
            case .AllInOne:
                
                let cell: EventTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.selectionStyle = .none
                
                let event = Event()
                event.title = "20% скидка на все кальяны! "
                event.location = "Мята Бар"
                event.time = "Ежедневно 20:00-00:00"
                event.eventType = "Акция"
                
                cell.configure(wtih: event)
                
                return cell
                
            }
        
        case 2:
            
            let cell: NewPlacesListTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
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
        listViewSwitchButton.isHidden = true
        filterButton.isHidden = false
        
        searchView.isHidden = true
    }
}
