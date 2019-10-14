//
//  BookTableViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/30/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class BookTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var viewModel: BookTableViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(BookingUsernameTableViewCell.self)
        tableView.register(BookingDateAndTimeTableViewCell.self)
        tableView.register(BookingInviteFriendsTableViewCell.self)
        tableView.register(BookingPhoneNumberTableViewCell.self)
        tableView.register(BookingWishesTableViewCell.self)
    }
    
    private func configureNavBar() {
        navItem.title = "Бронирование"
        
        let cancelButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelBooking))
        cancelButton.tintColor = Color.red
        navItem.leftBarButtonItem = cancelButton
        
        let confirmButton = UIBarButtonItem(title: "Отправить", style: .plain, target: self, action: #selector(confirmBooking))
        confirmButton.tintColor = Color.blue
        navItem.rightBarButtonItem = confirmButton
    }

    @objc private func cancelBooking() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func confirmBooking() {
        viewModel.bookTable()
    }
    
}

extension BookTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bookingParameters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel.bookingParameters[indexPath.row].type {
        case .dateTime:
            
            let cell: BookingDateAndTimeTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(parameter: viewModel.bookingParameters[indexPath.row])
            return cell
            
        case .numberOfGuest:
            
            let cell: BookingInviteFriendsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(parameter: viewModel.bookingParameters[indexPath.row])
            cell.parentVC = self
            return cell
            
        case .username:
            
            let cell: BookingUsernameTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(parameter: viewModel.bookingParameters[indexPath.row])
            return cell
        
        case .phoneNumber:
            
            let cell: BookingPhoneNumberTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(parameter: viewModel.bookingParameters[indexPath.row])
            return cell
        
        case .wishes:
            
            let cell: BookingWishesTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(parameter: viewModel.bookingParameters[indexPath.row])
            return cell
            
        }
        
    }
}
