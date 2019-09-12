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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        tableView.register(LastSearchTableViewCell.self)
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
            btn.top == view.top
            btn.bottom == view.bottom
            btn.width == 200
            btn.centerX == view.centerX
        }
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LastSearchTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
        cell.configure(with: "Traveler's coffee")
        
        return cell
    }
}
