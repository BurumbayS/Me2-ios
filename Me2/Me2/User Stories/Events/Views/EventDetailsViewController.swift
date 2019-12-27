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
    
    var viewModel: EventDetailsViewModel!
    
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
                self?.tableView.reloadData()
            case .error:
                break
            case .fail:
                break
            }
        }
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
    
    private func shareEvent() {
        self.addActionSheet(titles: ["Личным сообщением","Другие соц.сети"], actions: [shareEventInApp, shareEventViaSocial], styles: [.default, .default])
    }
    
    private func shareEventViaSocial() {
        let str = viewModel.event.generateShareInfo()
        
        let activityViewController = UIActivityViewController(activityItems: [str], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func shareEventInApp() {
        let vc = Storyboard.ShareInAppViewController() as! ShareInAppViewController
        let data = ["event": viewModel.eventJSON.dictionaryObject]
        vc.viewModel = ShareInAppViewModel(data: data)
        self.present(vc, animated: true, completion: nil)
    }
}

extension EventDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.event != nil { return 5 } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            
            let cell: EventDetailHeaderTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(with: viewModel.event, on: self) { [weak self] in
                self?.shareEvent()
            }
            return cell
        
        case 1:
            
            let cell: EventDescriptionTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(with: viewModel.event.title, and: viewModel.event.description ?? "")
            return cell
            
        case 2:
            
            let cell: TagsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(tagsType: .unselectable, tagsList: TagsList(items: viewModel.event.tags))
            return cell
            
        case 3:
            
            let cell: EventPlaceTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            cell.configure(with: viewModel.event.place)
            return cell
            
        case 4:
            
            let cell: EventAddressTimeTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configure(with: viewModel.event.place.address1, and: viewModel.event.getTime())
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            let vc = Storyboard.placeProfileViewController() as! PlaceProfileViewController
            vc.viewModel = PlaceProfileViewModel(place: viewModel.event.place)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
