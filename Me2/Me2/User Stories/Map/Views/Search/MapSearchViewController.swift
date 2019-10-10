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
        tableView.reloadSections([0], with: .automatic)
    }
}

extension MapSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        
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
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if viewModel.searchResults.count == 0 && viewModel.lastSearchResults.count > 0 {
            return 60
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.searchValue.value != "" {
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
            
            viewModel.lastSearchResults.append(viewModel.searchResults[indexPath.row].name)
            UserDefaults().set(viewModel.lastSearchResults, forKey: UserDefaultKeys.lastMapSearchResults.rawValue)
            
            let vc = Storyboard.placeProfileViewController()
            presenterDelegate.present(controller: vc)
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
