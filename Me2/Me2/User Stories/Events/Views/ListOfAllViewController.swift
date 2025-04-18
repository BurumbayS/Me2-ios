//
//  ListOfAllViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/25/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class ListOfAllViewController: BaseViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ListOfAllViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTableView()
        fetchData()
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
    
    private func configureNavBar() {
        navBar.isTranslucent = false
        navBar.tintColor = .black
        
        self.setUpBackBarButton(for: navItem)
        self.navItem.title = viewModel.category.title
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
        return viewModel.getNumberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.listItemType {
        case .event:
        
            let cell: EventTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            
            var onFollowPresed: VoidBlock? = nil
            if viewModel.category == .saved {
                onFollowPresed = { [weak self] in
                    self?.viewModel.eventsList.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
            
            cell.configure(wtih: viewModel.eventsList[indexPath.row], onFollowPressed: onFollowPresed)
            return cell
        
        case .place:
            
            let cell: PlaceTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(with: viewModel.placesList[indexPath.row])
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.listItemType {
        case .event:
            
            let dest = Storyboard.eventDetailsViewController() as! UINavigationController
            let vc = dest.viewControllers[0] as! EventDetailsViewController
            vc.viewModel = EventDetailsViewModel(eventID: viewModel.eventsList[indexPath.row].id)
            present(dest, animated: true, completion: nil)
            
        case .place:
            
            let vc = Storyboard.placeProfileViewController() as! PlaceProfileViewController
            vc.viewModel = PlaceProfileViewModel(place: viewModel.placesList[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}
