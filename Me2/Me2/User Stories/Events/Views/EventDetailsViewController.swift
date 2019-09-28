//
//  EventDetailsViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/26/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTableView()
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.isHidden = true
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsets(top: (-1) * UIApplication.shared.statusBarFrame.height, left: 0, bottom: 20, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.separatorStyle = .none
        
        tableView.register(EventDetailHeaderTableViewCell.self)
        tableView.register(EventDescriptionTableViewCell.self)
        tableView.register(TagsTableViewCell.self)
        tableView.register(EventPlaceTableViewCell.self)
        tableView.registerNib(EventAddressTimeTableViewCell.self)
    }
}

extension EventDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            
            let cell: EventDetailHeaderTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: "Акция", and: "https://img-fotki.yandex.ru/get/15555/191838361.33/0_dfde8_53b55031_XXL.jpg")
            return cell
        
        case 1:
            
            let cell: EventDescriptionTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: "-20% скидка на все кальяны! ", and: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor inci idunt ut labore et dolore mag aliquaUt en ad minim veniam, quis nostrud.")
            return cell
            
        case 2:
            
            let cell: TagsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: .unselectable)
            return cell
            
        case 3:
            
            let cell: EventPlaceTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.configure()
            return cell
            
        case 4:
            
            let cell: EventAddressTimeTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: "Желтоксана, 137, 1 этаж, Алмалинский район", and: "Ежедневно 20:00-00:00")
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
