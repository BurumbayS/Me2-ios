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
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
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
        
        tableView.register(ListItemTableViewCell.self)
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ListItemTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
        cell.configure(with: "Арабская")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.popViewController(animated: true)
    }
}
