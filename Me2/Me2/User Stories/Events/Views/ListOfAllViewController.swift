//
//  ListOfAllViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/25/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class ListOfAllViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ListOfAllViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        
        tableView.registerNib(EventTableViewCell.self)
        tableView.registerNib(PlaceTableViewCell.self)
    }
}

extension ListOfAllViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.listItemType {
        case .event:
        
            let cell: EventTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
//            let event = Event()
//            event.title = "20% скидка на все кальяны! "
//            event.location = "Мята Бар"
//            event.time = "Ежедневно 20:00-00:00"
//            event.eventType = "Акция"
//            cell.configure(wtih: event)
            return cell
        
        case .place:
            
            let cell: PlaceTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dest = Storyboard.eventDetailsViewController()
        self.present(dest, animated: true, completion: nil)
    }
}
