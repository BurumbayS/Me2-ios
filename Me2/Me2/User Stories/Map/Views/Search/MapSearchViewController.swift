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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.searchValue.bind { [unowned self] (value) in
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
}

extension MapSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        
        let button = UIButton()
        button.setTitle("Очистить историю", for: .normal)
        button.setTitleColor(Color.red, for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 17)
        
        footer.addSubview(button)
        constrain(button, footer) { btn, view in
            btn.top == view.top + 30
            btn.bottom == view.bottom
            btn.width == 200
            btn.centerX == view.centerX
        }
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if viewModel.searchResults.count == 0 {
            return 60
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.searchResults.count > 0 {
            return viewModel.searchResults.count
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel.searchResults.count {
        case 0:
            
            let cell: LastSearchTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            
            cell.configure(with: "Traveler's coffee")
            
            return cell
            
        default:
            
            let cell: PlaceTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            
            return cell
            
        }
    }
}
