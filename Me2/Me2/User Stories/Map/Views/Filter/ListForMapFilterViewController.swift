//
//  ListForMapFilterViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/16/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class ListForMapFilterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ListForMapFilterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        fetchData()
        configureNavBar()
        configureTableView()
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.title = "Тип заведения"
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(MapSearchFilterTableViewCell.self)
    }
    
    private func fetchData() {
        viewModel.fetchData { [weak self] (status, message) in
            switch status {
            case .ok:
                
                self?.tableView.reloadSections([0], with: .automatic)
                
            case .error:
                break
            case .fail:
                break
            }
        }
    }
}

extension ListForMapFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        
        let searchBar = SearchBar.instanceFromNib()
        searchBar.backgroundColor = Color.lightGray
        
        header.addSubview(searchBar)
        constrain(searchBar, header) { bar, header in
            bar.left == header.left + 10
            bar.right == header.right - 10
            bar.top == header.top
            bar.bottom == header.bottom
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MapSearchFilterTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
        cell.selectionStyle = .none
        let selected = viewModel.tag_ids.value.contains(viewModel.tags[indexPath.row].id)
        cell.configure(with: viewModel.tags[indexPath.row].name, filterType: .check, selected: selected)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectTag(at: indexPath)
        tableView.reloadData()
    }
}
