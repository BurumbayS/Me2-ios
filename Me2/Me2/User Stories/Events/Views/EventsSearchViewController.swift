//
//  EventsSearchViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/25/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class EventsSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var helperLabel: UILabel!
    
    var viewModel: EventsSearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    func configure(with viewModel: EventsSearchViewModel) {
        self.viewModel = viewModel
    }
    
    private func configureTableView() {
        tableView.isHidden = true
    }

}
