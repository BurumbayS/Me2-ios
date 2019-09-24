//
//  EventsTabViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/23/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class EventsTabViewController: UIViewController {

    var searchBar: SearchBar!
    let listViewSwitchButton = UIButton()
    let tableView = UITableView()
    
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
        
        tableView.register(SavedEventsTableViewCell.self)
        tableView.register(EventsListTableViewCell.self)
        tableView.register(NewPlacesListTableViewCell.self)
    }
    
    private func setUpViews() {
        searchBar = SearchBar.instanceFromNib()
        searchBar.backgroundColor = Color.gray
        self.view.addSubview(searchBar)
        constrain(searchBar, self.view) { search, view in
            search.left == view.left + 20
            search.top == view.top + 40
            search.height == 36
        }
        
        listViewSwitchButton.setImage(UIImage(named: "listView_icon"), for: .normal)
        listViewSwitchButton.imageView?.contentMode = .scaleAspectFit
        self.view.addSubview(listViewSwitchButton)
        constrain(listViewSwitchButton, searchBar, self.view) { btn, search, view in
            btn.right == view.right - 20
            btn.centerY == search.centerY
            btn.left == search.right + 20
            btn.height == 25
            btn.width == 25
        }
        
        self.view.addSubview(tableView)
        constrain(tableView, searchBar, self.view) { table, search, view in
            table.top == search.bottom + 20
            table.left == view.left
            table.right == view.right
            table.bottom == view.bottom
        }
    }
}

extension EventsTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        
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
        switch section {
        case 0:
            return 0
        default:
            return 40
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            let cell: SavedEventsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            
            cell.accessoryType = .disclosureIndicator
            cell.configure(with: 3)
            
            return cell
            
        case 1:
            
            let cell: EventsListTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
        
        case 2:
            
            let cell: NewPlacesListTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
