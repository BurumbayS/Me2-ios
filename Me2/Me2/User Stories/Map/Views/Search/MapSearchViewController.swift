//
//  MapSearchViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/12/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class MapSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MapSearchViewModel!
    var presenterDelegate: ControllerPresenterDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        bindViewModel()
    }
    
    func configure(with viewModel: MapSearchViewModel, delegate: ControllerPresenterDelegate) {
        self.viewModel = viewModel
        self.presenterDelegate = delegate
    }
    
    private func bindViewModel() {
        viewModel.updateSearchResults.bind { [unowned self] (value) in
            self.tableView.reloadSections([0], with: .automatic)
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        tableView.register(LastSearchTableViewCell.self)
        tableView.registerNib(PlaceTableViewCell.self)
    }
    
    @objc private func clearLastSearchResults() {
        viewModel.lastSearchResults = []
        UserDefaults().set(viewModel.lastSearchResults, forKey: UserDefaultKeys.lastMapSearchResults.rawValue)
        tableView.reloadSections([0], with: .automatic)
    }
}

extension MapSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        
        if (viewModel.searchValue.value != "" || viewModel.filterData.value.count > 0) && viewModel.searchResults.count == 0 {
            
            let label = UILabel()
            label.textColor = .gray
            label.font = UIFont(name: "Roboto-Regular", size: 17)
            label.text = "Ничего не найдено"
            
            footer.addSubview(label)
            constrain(label, footer) { label, view in
                label.centerX == view.centerX
                label.centerY == view.centerY
            }
            
        } else
        if viewModel.searchResults.count == 0 && viewModel.lastSearchResults.count > 0 {
            
            if viewModel.searchResults.count == 0 && viewModel.lastSearchResults.count > 0 {
                
                let button = UIButton()
                button.setTitle("Очистить историю", for: .normal)
                button.setTitleColor(Color.red, for: .normal)
                button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 17)
                button.addTarget(self, action: #selector(clearLastSearchResults), for: .touchUpInside)
                
                footer.addSubview(button)
                constrain(button, footer) { btn, view in
                    btn.top == view.top + 30
                    btn.bottom == view.bottom
                    btn.width == 200
                    btn.centerX == view.centerX
                }
                
            }
            
        }
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if viewModel.searchResults.count > 0 {
            return 0
        } else {
            return 60
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (viewModel.searchValue.value != "" || viewModel.filterData.value.count > 0) {
            return viewModel.searchResults.count
        } else {
            return viewModel.lastSearchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel.searchResults.count {
        case 0:
            
            let cell: LastSearchTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            
            cell.configure(with: viewModel.lastSearchResults[indexPath.row])
            
            return cell
            
        default:
            
            let cell: PlaceTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            
            cell.configure(with: viewModel.searchResults[indexPath.row])
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.searchResults.count {
        case 0:
            
            viewModel.searchValue.value = viewModel.lastSearchResults[indexPath.row]
            
        default:
            
            viewModel.addToLastSearchResults(result: viewModel.searchResults[indexPath.row].name)
            
            let vc = Storyboard.placeProfileViewController() as! PlaceProfileViewController
            vc.viewModel = PlaceProfileViewModel(place: viewModel.searchResults[indexPath.row])
            presenterDelegate.present(controller: vc, presntationType: .push, completion: nil)
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
