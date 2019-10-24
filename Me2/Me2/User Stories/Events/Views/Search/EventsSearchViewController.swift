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
    var presenterDelegate: ControllerPresenterDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    func configure(with viewModel: EventsSearchViewModel, and presenterDelegate: ControllerPresenterDelegate) {
        self.viewModel = viewModel
        self.presenterDelegate = presenterDelegate
        
        viewModel.updateSearchResults.bind { [weak self] (_) in
            if (self?.viewModel.searchResults.count)! > 0 {
                self?.tableView.isHidden = false
                self?.tableView.reloadData()
            } else {
                self?.tableView.isHidden = true
            }
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.isHidden = true
        
        tableView.registerNib(EventTableViewCell.self)
    }

}

extension EventsSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        cell.configure(wtih: viewModel.searchResults[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dest = Storyboard.eventDetailsViewController() as! UINavigationController
        let vc = dest.viewControllers[0] as! EventDetailsViewController
        vc.viewModel = EventDetailsViewModel(eventID: viewModel.searchResults[indexPath.row].id)
        presenterDelegate.present(controller: dest, presntationType: .present)
    }
}
