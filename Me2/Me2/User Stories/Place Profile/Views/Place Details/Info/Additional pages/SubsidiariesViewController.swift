//
//  SubsidiariesViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 12/12/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class SubsidiariesViewController: UIViewController {

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    var subsidiaries = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureNavBar()
    }
    
    private func configureNavBar() {
        navBar.tintColor = .black
        
        navItem.title = "Филиалы"
        setUpBackBarButton(for: navItem)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(PlaceTableViewCell.self)
    }

}

extension SubsidiariesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subsidiaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlaceTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(with: subsidiaries[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = Storyboard.placeProfileViewController() as! PlaceProfileViewController
        vc.viewModel = PlaceProfileViewModel(place: subsidiaries[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
