//
//  NotificationsViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 11/1/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = NotificationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTableView()
        fetchData()
    }
    
    private func fetchData() {
        viewModel.getNotifications { [weak self] (status, message) in
            self?.tableView.reloadData()
        }
    }
    
    private func configureNavBar() {
        navBar.isTranslucent = false
        navBar.tintColor = .black
        setUpBackBarButton(for: navItem)
        
        navItem.title = "Уведомления"
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        
        tableView.register(NotificationTableViewCell.self)
    }
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotificationTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(notification: viewModel.notifications[indexPath.row])
        return cell
    }
}
