//
//  CreateGroupViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/6/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class CreateGroupViewController: UIViewController {
    
    let tableView = UITableView()
    let searchBar = SearchBar.instanceFromNib()
    let participantsLabel = UILabel()
    
    let viewModel = CreateGroupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setUpNavBar()
        setUpViews()
        setUpTableView()
    }
    
    
    private func bindViewModel() {
        viewModel.participants.bind { [weak self] (participants) in
            self?.updateGroup(with: participants)
        }
    }
    
    private func updateGroup(with participants : [String]) {
        let participantsString = toString(from: participants)
        
        if participantsString == "" {
            navigationItem.rightBarButtonItem?.isEnabled = false
            participantsLabel.textColor = .lightGray
            participantsLabel.font = UIFont(name: "Roboto-Regular", size: 13)
            participantsLabel.text = "Выберите участников группы"
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            participantsLabel.textColor = .black
            participantsLabel.font = UIFont(name: "Roboto-Regular", size: 17)
            participantsLabel.text = toString(from: participants)
        }
    }
    
    private func setUpNavBar() {
        navigationController?.navigationBar.tintColor = Color.red
        navigationController?.navigationBar.shouldRemoveShadow(true)
        
        navigationItem.title = "Участники"
        
        let rightItem = UIBarButtonItem(title: "Далее", style: .plain, target: self, action: #selector(goNext))
        rightItem.tintColor = Color.blue
        navigationItem.rightBarButtonItem = rightItem
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let leftItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(goBack))
        leftItem.tintColor = Color.red
        navigationItem.leftBarButtonItem = leftItem
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    @objc private func goNext() {
        let vc = Storyboard.modifyGroupViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setUpViews() {
        searchBar.backgroundColor = Color.lightGray
        
        self.view.addSubview(searchBar)
        constrain(searchBar, self.view) { search, view in
            search.left == view.left + 10
            search.right == view.right - 10
            search.top == view.top + 10
            search.height == 36
        }
        
        participantsLabel.textColor = .lightGray
        participantsLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        participantsLabel.numberOfLines = 0
        participantsLabel.text = "Выберите участников группы"
        self.view.addSubview(participantsLabel)
        constrain(participantsLabel, searchBar, self.view) { label, search, view in
            label.top == search.bottom + 17
            label.left == view.left + 10
            label.right == view.right - 10
        }
        
        self.view.addSubview(tableView)
        constrain(tableView, participantsLabel, self.view) { table, label, view in
            table.left == view.left
            table.right == view.right
            table.top == label.bottom + 15
            table.bottom == view.bottom
        }
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        
        for i in 0..<20 {
            tableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableCell\(i)")
        }
    }
}

extension CreateGroupViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = Color.lightGray
        
        let letterLabel = UILabel()
        letterLabel.text = "A"
        letterLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        letterLabel.textColor = .gray
        
        headerView.addSubview(letterLabel)
        constrain(letterLabel, headerView) { letter, view in
            letter.left == view.left + 26
            letter.top == view.top
            letter.bottom == view.bottom
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableCell\(indexPath.row)", for: indexPath) as! ContactTableViewCell
//        cell.configure(selectable: true)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ContactTableViewCell {
            viewModel.select(cell: cell)
        }
    }
}

extension CreateGroupViewController  {
    private func toString(from array : [String]) -> String {
        var string = ""
        
        for (i, item) in array.enumerated() {
            string += item
            
            if i != array.count - 1 {
                string += ","
            }
        }
        
        return string
    }
}
